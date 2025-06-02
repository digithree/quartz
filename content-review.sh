#!/bin/bash

set -e

# Check dependencies
for tool in gh jq claude; do
  if ! command -v $tool >/dev/null 2>&1; then
    echo "Error: '$tool' is not installed or not in PATH."
    exit 1
  fi
done

# Ensure we are on a content branch
branch_name=$(git rev-parse --abbrev-ref HEAD)
if [[ ! "$branch_name" =~ ^content/[0-9]{2}-[0-9]{2}-[0-9]{2}-[0-9]{2}$ ]]; then
  echo "Error: Current branch '$branch_name' does not match content branch pattern."
  exit 1
fi

echo "Checking for PR associated with branch: $branch_name..."

# Get the pull request number
pr_json=$(gh pr view "$branch_name" --json number)
pr_number=$(echo "$pr_json" | jq -r '.number')

if [[ -z "$pr_number" || "$pr_number" == "null" ]]; then
  echo "Error: No PR found for branch '$branch_name'."
  exit 1
fi

echo "Found PR #$pr_number. Waiting for Copilot review..."

# Get timestamp of most recent commit in the PR branch and convert to epoch
last_commit_time=$(git log -1 --format="%cI" "$branch_name")
# Strip colon from timezone offset to make it compatible with macOS `date`
last_commit_cleaned=$(echo "$last_commit_time" | sed -E 's/([+-][0-9]{2}):([0-9]{2})/\1\2/')

if date -j -f "%Y-%m-%dT%H:%M:%S%z" "$last_commit_cleaned" "+%s" >/dev/null 2>&1; then
  last_commit_epoch=$(date -j -f "%Y-%m-%dT%H:%M:%S%z" "$last_commit_cleaned" "+%s")
else
  last_commit_epoch=$(date -d "$last_commit_time" "+%s")
fi

attempt=1
while true; do
  echo "Polling for Copilot review via review events (attempt $attempt)..."

  reviews_json=$(gh api "repos/$(gh repo view --json nameWithOwner -q .nameWithOwner)/pulls/$pr_number/reviews")

  copilot_review=$(echo "$reviews_json" | jq --argjson ts "$last_commit_epoch" '
    [ .[]
      | select(.user.login == "copilot-pull-request-reviewer[bot]")
      | . as $r
      | ($r.submitted_at | fromdateiso8601) as $submitted
      | select($submitted > $ts)
    ][-1]')

  if [[ -z "$copilot_review" || "$copilot_review" == "null" ]]; then
    echo "Waiting for Copilot review after last commit... (attempt $attempt)"
    attempt=$((attempt + 1))
    sleep 30
    continue
  fi

  copilot_review_body=$(echo "$copilot_review" | jq -r '.body')

  echo "Copilot review found."

  # Save review body to file
  mkdir -p pr-review
  echo "$copilot_review_body" > "pr-review/$pr_number.md"

  if echo "$copilot_review_body" | grep -q "generated no comments"; then
    echo "Copilot generated no comments. Merging PR..."
    gh pr merge "$pr_number" --merge --delete-branch
    echo "PR merged. Syncing to main..."
    ./content-sync.sh
    break
  elif echo "$copilot_review_body" | grep -Eq "generated [0-9]+ comment(s)?\.?"; then
    review_path="pr-review/$pr_number.md"
    response=$(cat "$review_path" | claude -p "Please review the following GitHub Copilot pull request review. Are there comments requesting changes, and if so, are any of them important or correctable issue (not including nitpicks or low-confidence suggestions but including spelling or grammar issues)? Answer ONLY with a single word: yes or no")
    if [[ "$response" == "yes" ]]; then
      echo "Copilot generated comments. Review saved to pr-review/$pr_number.md"
    else
      echo "Copilot generated no significant comments. Merging PR..."
      gh pr merge "$pr_number" --merge --delete-branch
      echo "PR merged. Syncing to main..."
      ./content-sync.sh
    fi
    break
  else
    echo "Unexpected Copilot review format. Raw output:"
    echo "$copilot_review_body"
    break
  fi
done

echo -e "\a"

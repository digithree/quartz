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
if [[ ! "$branch_name" =~ ^content/[0-9]{2}-[0-9]{2}-[0-9]{2}-.+$ ]]; then
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
  # Get all review comments (code comments) from Copilot
  comments_json=$(gh api "repos/$(gh repo view --json nameWithOwner -q .nameWithOwner)/pulls/$pr_number/comments")

  copilot_comments=$(echo "$comments_json" | jq --argjson ts "$last_commit_epoch" '
    [ .[]
      | select(.user.login == "Copilot")
      | . as $c
      | ($c.created_at | fromdateiso8601) as $created
      | select($created > $ts)
    ]')

  if [[ -z "$copilot_comments" || "$copilot_comments" == "null" || "$copilot_comments" == "[]" ]]; then
    echo "Waiting for Copilot review comments after last commit... (attempt $attempt)"
    attempt=$((attempt + 1))
    sleep 30
    continue
  fi

  comment_count=$(echo "$copilot_comments" | jq 'length')
  echo "Copilot review found with $comment_count code comment(s)."

  if [[ "$comment_count" -eq 0 ]]; then
    echo "Copilot generated no code comments. Merging PR..."
    gh pr merge "$pr_number" --squash --delete-branch
    break
  else
    # Save comments to file
    mkdir -p pr-review
    echo "$copilot_comments" | jq -r '.[] | "## File: \(.path)\nLine: \(.line // .original_line)\n\n\(.body)\n"' > "pr-review/$pr_number.md"
    echo "Copilot generated $comment_count code comment(s). Review saved to pr-review/$pr_number.md; please review."
    break
  fi
done

echo -e "\a"

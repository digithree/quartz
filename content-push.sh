#!/bin/bash

set -e

# Check dependencies
for tool in gh jq; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Error: '$tool' is required but not installed or not in PATH."
    exit 1
  fi
done

# Get the current branch name
branch_name=$(git rev-parse --abbrev-ref HEAD)

# Check if the branch name matches the expected pattern
if [[ ! "$branch_name" =~ ^content/([0-9]{2}-[0-9]{2}-[0-9]{2})-([0-9]{2})$ ]]; then
  echo "Error: Current branch '$branch_name' does not match the expected pattern 'content/YY-MM-DD-XX'"
  exit 1
fi

# Extract date and suffix from the branch name
date_part="${BASH_REMATCH[1]}"
suffix_part="${BASH_REMATCH[2]}"

# Push the branch to origin
git push -u origin "$branch_name"

# Check if a PR already exists for this branch
pr_number=$(gh pr view "$branch_name" --json number 2>/dev/null | jq -r '.number')

if [[ "$pr_number" == "null" || -z "$pr_number" ]]; then
  echo "Creating pull request for branch: $branch_name"
  gh pr create \
    --title "$branch_name" \
    --body "Content update for $date_part, number $suffix_part." \
    --base main \
    --head "$branch_name"
else
  echo "Pull request already exists for branch: $branch_name (PR #$pr_number)"

  # Get last commit time and Copilot review timestamps to decide whether to open the PR in browser
  last_commit_time=$(git log -1 --format="%cI" "$branch_name")
  last_commit_cleaned=$(echo "$last_commit_time" | sed -E 's/([+-][0-9]{2}):([0-9]{2})/\1\2/')
  if date -j -f "%Y-%m-%dT%H:%M:%S%z" "$last_commit_cleaned" "+%s" >/dev/null 2>&1; then
    last_commit_epoch=$(date -j -f "%Y-%m-%dT%H:%M:%S%z" "$last_commit_cleaned" "+%s")
  else
    last_commit_epoch=$(date -d "$last_commit_time" "+%s")
  fi

  reviews_json=$(gh api "repos/$(gh repo view --json nameWithOwner -q .nameWithOwner)/pulls/$pr_number/reviews")

  copilot_review=$(echo "$reviews_json" | jq --argjson ts "$last_commit_epoch" '
    [ .[]
      | select(.user.login == "copilot-pull-request-reviewer[bot]")
      | . as $r
      | ($r.submitted_at | fromdateiso8601) as $submitted
      | select($submitted < $ts)
    ][-1]')

  if [[ "$copilot_review" != "null" && -n "$copilot_review" ]]; then
    echo "Copilot review found but predates latest commit. Opening PR in browser..."
    gh pr view "$branch_name" --web
  fi
fi

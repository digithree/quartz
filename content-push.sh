#!/bin/bash

set -e

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

# Create the pull request using GitHub CLI with branch name as title (default), custom body
gh pr create \
  --title "$branch_name" \
  --body "Content update for $date_part, number $suffix_part." \
  --base main \
  --head "$branch_name"

echo "Pull request created for branch: $branch_name"

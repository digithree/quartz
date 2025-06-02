#!/bin/bash

set -e

# Check required tools
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

echo "Locating PR number for branch: $branch_name..."
pr_json=$(gh pr view "$branch_name" --json number)
pr_number=$(echo "$pr_json" | jq -r '.number')

if [[ -z "$pr_number" || "$pr_number" == "null" ]]; then
  echo "Error: No PR found for branch '$branch_name'."
  exit 1
fi

review_path="pr-review/$pr_number.md"

if [[ ! -f "$review_path" ]]; then
  echo "Error: Review file '$review_path' not found. Run the review collection script first."
  exit 1
fi

echo "Running Claude on review comments from: $review_path"

echo "--- Claude input start ---"
cat "$review_path"
echo "--- Claude input end ---"

echo "Sending to Claude..."

cat "$review_path" | claude "Please review the following GitHub Copilot pull request review. For each comment, automatically apply changes to the code if the comment identifies an important or correctable issue. Do not apply nitpicks, low-confidence suggestions, or comments about documentation unless critical or related to spelling or grammar. Return a clear list of changed files, diffs, or commands used. Assume the repo is clean and you can modify files in place."

echo "Claude suggestion complete. Please apply changes manually or automate further if safe."

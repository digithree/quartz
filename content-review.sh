#!/bin/bash

set -e

# Check dependencies
if ! command -v gh >/dev/null 2>&1; then
  echo "Error: 'gh' CLI (GitHub CLI) is not installed or not in PATH."
  echo "Install it from https://cli.github.com/"
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "Error: 'jq' is not installed or not in PATH."
  echo "Install it with 'brew install jq' (macOS) or your system's package manager."
  exit 1
fi

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

attempt=1
while true; do
  echo "Polling for Copilot review via review events (attempt $attempt)..."

  reviews_json=$(gh api "repos/$(gh repo view --json nameWithOwner -q .nameWithOwner)/pulls/$pr_number/reviews")

  copilot_review_body=$(echo "$reviews_json" | jq -r '.[] | select(.user.login == "copilot-pull-request-reviewer[bot]") | .body' | head -n 1)

  if [[ -z "$copilot_review_body" ]]; then
    echo "Waiting for Copilot review... (attempt $attempt)"
    attempt=$((attempt + 1))
    sleep 30
    continue
  fi

  echo "Copilot review found."

  if echo "$copilot_review_body" | grep -q "generated no comments"; then
    echo "Copilot generated no comments. Merging PR..."
    gh pr merge "$pr_number" --merge --delete-branch
    echo "PR merged. Syncing to main..."
    ./content-sync.sh
    break
  elif echo "$copilot_review_body" | grep -q "generated [0-9]\+ comment"; then
    echo "Copilot generated review comments:"
    echo "-----------------------------------"
    echo "$copilot_review_body" | fold -s -w 80
    echo "-----------------------------------"
    break
  else
    echo "Unexpected Copilot review format. Raw output:"
    echo "$copilot_review_body"
    break
  fi

done

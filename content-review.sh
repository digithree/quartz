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
pr_json=$(gh pr view "$branch_name" --json number,comments)
pr_number=$(echo "$pr_json" | jq -r '.number')

if [[ -z "$pr_number" || "$pr_number" == "null" ]]; then
  echo "Error: No PR found for branch '$branch_name'."
  exit 1
fi

echo "Found PR #$pr_number. Waiting for Copilot review..."

while true; do
  # Fetch PR comments as JSON
  comments_json=$(gh pr view "$pr_number" --json comments)
  copilot_comment=$(echo "$comments_json" | jq -r '.comments[] | select(.author.login == "github-copilot[bot]") | .body' | head -n 1)

  if [[ -z "$copilot_comment" ]]; then
    echo "Waiting for Copilot review..."
    sleep 30
    continue
  fi

  echo "Copilot review found."

  # Check if Copilot said "no comments"
  if echo "$copilot_comment" | grep -q "generated no comments"; then
    echo "Copilot generated no comments. Merging PR..."

    gh pr merge "$pr_number" --merge --delete-branch
    echo "PR merged. Syncing to main..."
    ./content-sync.sh
    break
  elif echo "$copilot_comment" | grep -q "generated [0-9][0-9]* comments"; then
    echo "Copilot generated review comments:"
    echo "-----------------------------------"
    echo "$copilot_comment" | fold -s -w 80
    echo "-----------------------------------"
    break
  else
    echo "Error: Unexpected Copilot comment format encountered."
    echo "Branch: $branch_name, PR: #$pr_number"
    echo "Raw Copilot comment output:"
    echo "-----------------------------------"
    echo "$copilot_comment" | fold -s -w 80
    echo "-----------------------------------"
    echo "Please check the PR manually or contact support for assistance."
    exit 1
  fi
done

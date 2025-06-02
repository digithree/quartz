#!/bin/bash

set -e

# Get the current branch name
branch_name=$(git rev-parse --abbrev-ref HEAD)

# Check if the branch name matches the expected pattern
if [[ "$branch_name" =~ ^content/[0-9]{2}-[0-9]{2}-[0-9]{2}-[0-9]{2}$ ]]; then
  echo "Current branch '$branch_name' matches content branch pattern."

  echo "Switching to 'main' branch..."
  git checkout main

  echo "Pulling latest changes from 'main'..."
  git pull origin main

  echo "Done."
else
  echo "Error: You are not on a content branch. Current branch is '$branch_name'."
  exit 1
fi

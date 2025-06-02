#!/bin/bash

set -e

# Ensure we're on the main branch
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$current_branch" != "main" ]; then
  echo "Error: You must be on the 'main' branch to create a new content branch."
  exit 1
fi

# Get current date in YY-MM-DD format
date_prefix=$(date +%y-%m-%d)

# Generate a random 6-character alphanumeric suffix
suffix=$(LC_ALL=C tr -dc 'a-z0-9' < /dev/urandom | head -c 6)

# Construct new branch name
new_branch="content/$date_prefix-$suffix"

# Create and switch to new branch
git checkout -b "$new_branch"
echo "Created and switched to new branch: $new_branch"

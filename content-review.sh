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

echo "Found PR #$pr_number. Fetching Copilot review..."

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
# Get all reviews from Copilot that are unresolved (state = "COMMENTED")
  reviews_json=$(gh api "repos/$(gh repo view --json nameWithOwner -q .nameWithOwner)/pulls/$pr_number/reviews")

  copilot_reviews=$(echo "$reviews_json" | jq --argjson ts "$last_commit_epoch" '
    [ .[]
      | select(.user.login == "copilot-pull-request-reviewer[bot]")
      | select(.state == "COMMENTED")
      | . as $r
      | ($r.submitted_at | fromdateiso8601) as $submitted
      | select($submitted > $ts)
    ]')

  if [[ -z "$copilot_reviews" || "$copilot_reviews" == "null" || "$copilot_reviews" == "[]" ]]; then
    echo "Waiting for Copilot review after last commit... (attempt $attempt)"
    attempt=$((attempt + 1))
    sleep 30
    continue
  fi
  cleaned_review=$(echo "$copilot_reviews" | jq -r '.[] | "## Review ID: \(.id)\nSubmitted: \(.submitted_at)\nState: \(.state)\n\n\(.body)\n\n---\n"' | sed '/<details>/q' | sed '$d')

  review_count=$(echo "$copilot_reviews" | jq 'length')
  echo "Found $review_count recent Copilot review(s)."

  if [[ "$review_count" -eq 0 ]]; then
    echo "No unresolved Copilot reviews found. Merging PR..."
    gh pr merge "$pr_number" --squash --delete-branch
    break
  else
    # Get all review comments (code comments) from Copilot using GraphQL
    repo_owner=$(gh repo view --json owner -q .owner.login)
    repo_name=$(gh repo view --json name -q .name)
    
    comments_json=$(gh api graphql -F pr_number="$pr_number" -f query="
      query(\$pr_number: Int!) {
        repository(owner: \"$repo_owner\", name: \"$repo_name\") {
          pullRequest(number: \$pr_number) {
            reviewThreads(first: 100) {
              nodes {
                isResolved
                comments(first: 10) {
                  nodes {
                    bodyText
                    author {
                      login
                    }
                  }
                }
              }
            }
          }
        }
      }
    ")

    # Filter for Copilot comments and count total/resolved/unresolved
    all_copilot_comments=$(echo "$comments_json" | jq '
      [.data.repository.pullRequest.reviewThreads.nodes[]
        | select(.comments.nodes[]?.author.login == "copilot-pull-request-reviewer")
      ]')
    
    total_comment_count=$(echo "$all_copilot_comments" | jq 'length')
    resolved_comment_count=$(echo "$all_copilot_comments" | jq '[.[] | select(.isResolved == true)] | length')
    unresolved_comment_count=$(echo "$all_copilot_comments" | jq '[.[] | select(.isResolved == false)] | length')
    
    echo "Total Copilot comments: $total_comment_count"
    echo "Resolved comments: $resolved_comment_count"
    echo "Unresolved comments: $unresolved_comment_count"

    if [[ "$unresolved_comment_count" -eq 0 ]]; then
      echo "No unresolved Copilot comments. Merging PR..."
      gh pr merge "$pr_number" --squash --delete-branch
      break
    else
      # Save only unresolved comments to file
      mkdir -p pr-review
      echo "$all_copilot_comments" | jq '
        [.[] | select(.isResolved == false)]
      ' > "pr-review/$pr_number.md"
      echo "Unresolved Copilot comments saved to pr-review/$pr_number.md; please review."
      break
    fi
  fi

done

echo -e "\a"

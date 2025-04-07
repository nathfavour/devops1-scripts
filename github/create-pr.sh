#!/bin/bash

# Import common functions
source ../utils/common.sh

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <title> <description> <head-branch> [base-branch]"
    echo "Example: $0 \"Add user authentication\" \"Implements OAuth authentication\" feature-auth main"
    exit 1
fi

# Load GitHub token
if [ -f ~/.config/devops-scripts/github.conf ]; then
    source ~/.config/devops-scripts/github.conf
else
    echo "Error: GitHub configuration not found."
    echo "Please run ../setup.sh to configure your GitHub credentials."
    exit 1
fi

# Check if we're in a git repo
if ! is_git_repo; then
    echo "Error: Not in a git repository."
    exit 1
fi

# Get repo information
REMOTE_URL=$(git config --get remote.origin.url)
REPO_FULL_NAME=$(echo $REMOTE_URL | sed -e 's/.*github.com[:\/]\(.*\)\.git/\1/')
if [ -z "$REPO_FULL_NAME" ]; then
    REPO_FULL_NAME=$(echo $REMOTE_URL | sed -e 's/.*github.com[:\/]\(.*\)/\1/')
fi

TITLE=$1
DESCRIPTION=$2
HEAD_BRANCH=$3
BASE_BRANCH=${4:-"main"}

# If head branch not specified, use current branch
if [ -z "$HEAD_BRANCH" ]; then
    HEAD_BRANCH=$(get_branch_name)
fi

echo "Creating pull request in $REPO_FULL_NAME"
echo "Title: $TITLE"
echo "From branch $HEAD_BRANCH to $BASE_BRANCH"

# Create pull request using GitHub API
RESPONSE=$(curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/$REPO_FULL_NAME/pulls \
  -d "{\"title\":\"$TITLE\",\"body\":\"$DESCRIPTION\",\"head\":\"$HEAD_BRANCH\",\"base\":\"$BASE_BRANCH\"}")

PR_URL=$(echo "$RESPONSE" | grep -o '"html_url": "[^"]*' | grep "/pull/" | head -1 | cut -d'"' -f4)

if [ -n "$PR_URL" ]; then
    echo "✅ Pull request created successfully: $PR_URL"
else
    echo "❌ Failed to create pull request. Response:"
    echo "$RESPONSE"
    exit 1
fi

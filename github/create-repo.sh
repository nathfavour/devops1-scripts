#!/bin/bash

# Import common functions
source ../utils/common.sh

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <repo-name> [description] [private|public]"
    exit 1
fi

REPO_NAME=$1
DESCRIPTION=${2:-""}
VISIBILITY=${3:-"private"}

# Convert visibility to boolean for API
if [ "$VISIBILITY" = "private" ]; then
    IS_PRIVATE="true"
else
    IS_PRIVATE="false"
fi

# Load GitHub token
if [ -f ~/.config/devops-scripts/github.conf ]; then
    source ~/.config/devops-scripts/github.conf
else
    echo "Error: GitHub configuration not found."
    echo "Please run ../setup.sh to configure your GitHub credentials."
    exit 1
fi

echo "Creating GitHub repository: $REPO_NAME..."

# Create repository using GitHub API
curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/user/repos \
  -d "{\"name\":\"$REPO_NAME\",\"description\":\"$DESCRIPTION\",\"private\":$IS_PRIVATE}" > /dev/null

if [ $? -eq 0 ]; then
    echo "✅ Repository created successfully: https://github.com/$(get_github_username)/$REPO_NAME"
    
    # Ask if user wants to initialize the repo locally
    read -p "Do you want to initialize this repository locally? (y/n): " INIT_LOCALLY
    if [[ $INIT_LOCALLY == "y" || $INIT_LOCALLY == "Y" ]]; then
        mkdir -p $REPO_NAME
        cd $REPO_NAME
        git init
        echo "# $REPO_NAME" > README.md
        echo "$DESCRIPTION" >> README.md
        git add README.md
        git commit -m "Initial commit"
        git branch -M main
        git remote add origin https://github.com/$(get_github_username)/$REPO_NAME.git
        git push -u origin main
        echo "✅ Repository initialized locally"
    fi
else
    echo "❌ Failed to create repository"
    exit 1
fi

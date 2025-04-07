#!/bin/bash

# Import common functions
source ../utils/common.sh

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <project-name> [description] [private|public|internal]"
    exit 1
fi

PROJECT_NAME=$1
DESCRIPTION=${2:-""}
VISIBILITY=${3:-"private"}

# Load GitLab token
if [ -f ~/.config/devops-scripts/gitlab.conf ]; then
    source ~/.config/devops-scripts/gitlab.conf
else
    echo "Error: GitLab configuration not found."
    echo "Please run ../setup.sh to configure your GitLab credentials."
    exit 1
fi

echo "Creating GitLab project: $PROJECT_NAME..."

# Create project using GitLab API
RESPONSE=$(curl -s -X POST \
  -H "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  -H "Content-Type: application/json" \
  "${GITLAB_API_URL}/projects" \
  -d "{\"name\":\"$PROJECT_NAME\",\"description\":\"$DESCRIPTION\",\"visibility\":\"$VISIBILITY\"}")

PROJECT_URL=$(echo "$RESPONSE" | grep -o '"web_url":"[^"]*' | head -1 | cut -d'"' -f4)

if [ -n "$PROJECT_URL" ]; then
    echo "✅ Project created successfully: $PROJECT_URL"
    
    # Ask if user wants to initialize the repo locally
    read -p "Do you want to initialize this repository locally? (y/n): " INIT_LOCALLY
    if [[ $INIT_LOCALLY == "y" || $INIT_LOCALLY == "Y" ]]; then
        mkdir -p $PROJECT_NAME
        cd $PROJECT_NAME
        git init
        echo "# $PROJECT_NAME" > README.md
        echo "$DESCRIPTION" >> README.md
        git add README.md
        git commit -m "Initial commit"
        git branch -M main
        git remote add origin $PROJECT_URL.git
        git push -u origin main
        echo "✅ Repository initialized locally"
    fi
else
    echo "❌ Failed to create project. Response:"
    echo "$RESPONSE"
    exit 1
fi

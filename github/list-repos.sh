#!/bin/bash

# Load GitHub token
if [ -f ~/.config/devops-scripts/github.conf ]; then
    source ~/.config/devops-scripts/github.conf
else
    echo "Error: GitHub configuration not found."
    echo "Please run ../setup.sh to configure your GitHub credentials."
    exit 1
fi

echo "Fetching your GitHub repositories..."

# Get username from token
USERNAME=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user | grep -o '"login": "[^"]*' | cut -d'"' -f4)

# Fetch repositories
REPOS=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/user/repos?per_page=100&sort=updated")

# Parse and display repositories
echo "Your GitHub repositories:"
echo "------------------------"
echo "$REPOS" | grep -o '"full_name": "[^"]*' | cut -d'"' -f4 | while read -r repo; do
    echo "$repo"
done

# Display count
COUNT=$(echo "$REPOS" | grep -c '"full_name":')
echo "------------------------"
echo "Total: $COUNT repositories"

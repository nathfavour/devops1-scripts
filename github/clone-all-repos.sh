#!/bin/bash

# Import common functions
source ../utils/common.sh

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <username-or-org> [destination-directory]"
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

USERNAME=$1
DEST_DIR=${2:-"$USERNAME-repos"}

# Create destination directory
mkdir -p "$DEST_DIR"
cd "$DEST_DIR" || exit 1

echo "Fetching repositories for $USERNAME..."

# Determine if it's a user or an organization
USER_TYPE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/users/$USERNAME" | grep -o '"type": "[^"]*' | cut -d'"' -f4)

if [ "$USER_TYPE" == "Organization" ]; then
    API_URL="https://api.github.com/orgs/$USERNAME/repos?per_page=100"
else
    API_URL="https://api.github.com/users/$USERNAME/repos?per_page=100"
fi

# Fetch repositories
REPOS=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "$API_URL")

# Parse and clone repositories
echo "Cloning repositories for $USERNAME into $DEST_DIR..."
echo "$REPOS" | grep -o '"ssh_url": "[^"]*' | cut -d'"' -f4 | while read -r repo_url; do
    repo_name=$(basename "$repo_url" .git)
    echo "Cloning $repo_name..."
    git clone "$repo_url"
done

# Display count
COUNT=$(echo "$REPOS" | grep -c '"name":')
echo "------------------------"
echo "✅ Cloned $COUNT repositories to $DEST_DIR"

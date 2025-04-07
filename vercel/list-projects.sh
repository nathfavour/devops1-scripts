#!/bin/bash

# Import common functions
source ../utils/common.sh

# Load Vercel token
if [ -f ~/.config/devops-scripts/vercel.conf ]; then
    source ~/.config/devops-scripts/vercel.conf
else
    echo "Error: Vercel configuration not found."
    echo "Please run ../setup.sh to configure your Vercel credentials."
    exit 1
fi

TEAM=$1

echo "Fetching Vercel projects..."

# Build command based on arguments
QUERY="https://api.vercel.com/v9/projects"

if [ -n "$TEAM" ]; then
    QUERY="$QUERY?teamId=$TEAM"
fi

# Fetch projects using Vercel API
RESPONSE=$(curl -s -H "Authorization: Bearer $VERCEL_TOKEN" $QUERY)

# Check if response contains projects
if echo "$RESPONSE" | grep -q '"projects":'; then
    echo "Your Vercel projects:"
    echo "--------------------"
    
    # Extract and display project names and URLs
    echo "$RESPONSE" | grep -o '"name":"[^"]*\|"link":"[^"]*' | cut -d'"' -f4 | 
    while read -r name && read -r link; do
        echo "$name - $link"
    done
    
    # Display count
    COUNT=$(echo "$RESPONSE" | grep -o '"name":' | wc -l)
    echo "--------------------"
    echo "Total: $COUNT projects"
else
    echo "No projects found or error in API response."
    echo "$RESPONSE"
    exit 1
fi

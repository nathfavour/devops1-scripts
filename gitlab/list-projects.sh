#!/bin/bash

# Load GitLab token and API URL
if [ -f ~/.config/devops-scripts/gitlab.conf ]; then
    source ~/.config/devops-scripts/gitlab.conf
else
    echo "Error: GitLab configuration not found."
    echo "Please run ../setup.sh to configure your GitLab credentials."
    exit 1
fi

echo "Fetching your GitLab projects..."

# Fetch projects with pagination
PAGE=1
PER_PAGE=100
TOTAL_PROJECTS=0
declare -a PROJECTS

while true; do
    RESPONSE=$(curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
        "$GITLAB_API_URL/projects?page=$PAGE&per_page=$PER_PAGE&membership=true&order_by=updated_at")
    
    # Check if array is empty or error
    if [ "$(echo "$RESPONSE" | grep -c '"id":')" -eq 0 ]; then
        break
    fi
    
    # Store project names
    while read -r line; do
        PROJECTS+=("$line")
    done < <(echo "$RESPONSE" | grep -o '"path_with_namespace":"[^"]*' | cut -d'"' -f4)
    
    # If fewer results than per_page, we've reached the end
    if [ "$(echo "$RESPONSE" | grep -c '"id":')" -lt $PER_PAGE ]; then
        break
    fi
    
    ((PAGE++))
done

# Display projects
echo "Your GitLab projects:"
echo "---------------------"
for project in "${PROJECTS[@]}"; do
    echo "$project"
done

# Display count
echo "---------------------"
echo "Total: ${#PROJECTS[@]} projects"

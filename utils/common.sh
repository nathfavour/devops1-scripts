#!/bin/bash

# Common utility functions

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Get current GitHub username
get_github_username() {
    if [ -z "$GITHUB_TOKEN" ]; then
        if [ -f ~/.config/devops-scripts/github.conf ]; then
            source ~/.config/devops-scripts/github.conf
        else
            echo "Error: GitHub configuration not found."
            return 1
        fi
    fi
    
    curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user | grep -o '"login": "[^"]*' | cut -d'"' -f4
}

# Get current GitLab username
get_gitlab_username() {
    if [ -z "$GITLAB_TOKEN" ] || [ -z "$GITLAB_API_URL" ]; then
        if [ -f ~/.config/devops-scripts/gitlab.conf ]; then
            source ~/.config/devops-scripts/gitlab.conf
        else
            echo "Error: GitLab configuration not found."
            return 1
        fi
    fi
    
    curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "$GITLAB_API_URL/user" | grep -o '"username":"[^"]*' | cut -d'"' -f4
}

# Check if we're inside a git repository
is_git_repo() {
    git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

# Get current branch name
get_branch_name() {
    git branch --show-current
}

# Check if file exists and is readable
check_file() {
    if [ ! -f "$1" ]; then
        echo "Error: File $1 not found."
        return 1
    fi
    
    if [ ! -r "$1" ]; then
        echo "Error: Cannot read file $1."
        return 1
    fi
    
    return 0
}

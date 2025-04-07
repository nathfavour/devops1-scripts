#!/bin/bash

# Import common functions
source ../utils/common.sh

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <project-directory> [environment] [team]"
    echo "Example: $0 ./my-react-app production my-team"
    exit 1
fi

PROJECT_DIR=$1
ENVIRONMENT=${2:-"production"}
TEAM=$3

# Check if Vercel CLI is installed
if ! command_exists vercel; then
    echo "Error: Vercel CLI not installed."
    echo "Install it with: npm i -g vercel"
    exit 1
fi

# Load Vercel token
if [ -f ~/.config/devops-scripts/vercel.conf ]; then
    source ~/.config/devops-scripts/vercel.conf
else
    echo "Error: Vercel configuration not found."
    echo "Please run ../setup.sh to configure your Vercel credentials."
    exit 1
fi

# Check if directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Directory $PROJECT_DIR not found."
    exit 1
fi

echo "Deploying project from $PROJECT_DIR to Vercel ($ENVIRONMENT environment)..."

# Set Vercel token in environment
export VERCEL_TOKEN

# Build command based on arguments
COMMAND="vercel $PROJECT_DIR --token=$VERCEL_TOKEN --prod"

if [ "$ENVIRONMENT" != "production" ]; then
    COMMAND="$COMMAND --environment=$ENVIRONMENT"
fi

if [ -n "$TEAM" ]; then
    COMMAND="$COMMAND --scope=$TEAM"
fi

# Execute deployment
echo "Running deployment command..."
eval $COMMAND

if [ $? -eq 0 ]; then
    echo "✅ Deployment successful"
else
    echo "❌ Deployment failed"
    exit 1
fi

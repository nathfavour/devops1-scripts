#!/bin/bash

echo "Setting up DevOps Scripts..."

# Create config directory if it doesn't exist
mkdir -p ~/.config/devops-scripts

# Ask for credentials if they don't exist
if [ ! -f ~/.config/devops-scripts/github.conf ]; then
    echo "Setting up GitHub credentials..."
    read -p "GitHub Personal Access Token: " github_token
    echo "GITHUB_TOKEN=$github_token" > ~/.config/devops-scripts/github.conf
fi

if [ ! -f ~/.config/devops-scripts/gitlab.conf ]; then
    echo "Setting up GitLab credentials..."
    read -p "GitLab Personal Access Token: " gitlab_token
    read -p "GitLab API URL [https://gitlab.com/api/v4]: " gitlab_url
    gitlab_url=${gitlab_url:-"https://gitlab.com/api/v4"}
    echo "GITLAB_TOKEN=$gitlab_token" > ~/.config/devops-scripts/gitlab.conf
    echo "GITLAB_API_URL=$gitlab_url" >> ~/.config/devops-scripts/gitlab.conf
fi

if [ ! -f ~/.config/devops-scripts/vercel.conf ]; then
    echo "Setting up Vercel credentials..."
    read -p "Vercel Access Token: " vercel_token
    echo "VERCEL_TOKEN=$vercel_token" > ~/.config/devops-scripts/vercel.conf
fi

if [ ! -f ~/.config/devops-scripts/aws.conf ]; then
    echo "Setting up AWS credentials..."
    read -p "AWS Access Key ID: " aws_access_key
    read -p "AWS Secret Access Key: " aws_secret_key
    read -p "AWS Default Region [us-east-1]: " aws_region
    aws_region=${aws_region:-"us-east-1"}
    
    echo "AWS_ACCESS_KEY_ID=$aws_access_key" > ~/.config/devops-scripts/aws.conf
    echo "AWS_SECRET_ACCESS_KEY=$aws_secret_key" >> ~/.config/devops-scripts/aws.conf
    echo "AWS_DEFAULT_REGION=$aws_region" >> ~/.config/devops-scripts/aws.conf
fi

echo "Creating requirements.txt..."
cat > requirements.txt << EOF
requests
boto3
python-gitlab
PyGithub
vercel-client
EOF

echo "Setup complete! You can now use the scripts."
echo "To install Python dependencies, run: pip install -r requirements.txt"

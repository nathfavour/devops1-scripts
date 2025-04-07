#!/bin/bash

# Import common functions
source ../utils/common.sh

# Load AWS credentials
if [ -f ~/.config/devops-scripts/aws.conf ]; then
    source ~/.config/devops-scripts/aws.conf
else
    echo "Error: AWS configuration not found."
    echo "Please run ../setup.sh to configure your AWS credentials."
    exit 1
fi

# Check if AWS CLI is installed
if ! command_exists aws; then
    echo "Error: AWS CLI not installed."
    echo "Install it with: pip install awscli"
    exit 1
fi

# Set AWS credentials
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION

echo "Listing EC2 instances in region $AWS_DEFAULT_REGION..."

# Get EC2 instances
INSTANCES=$(aws ec2 describe-instances)

# Check if there are instances
if echo "$INSTANCES" | grep -q '"Instances":'; then
    # Format and display instance information
    echo "$INSTANCES" | jq -r '.Reservations[].Instances[] | "\(.InstanceId) - \(.InstanceType) - \(.State.Name) - \(.PublicIpAddress // "No public IP") - \(if .Tags then .Tags[] | select(.Key == "Name") | .Value else "No Name" end)"' | 
    awk 'BEGIN{printf "%-12s %-12s %-12s %-16s %s\n", "INSTANCE ID", "TYPE", "STATE", "IP", "NAME"}
         {printf "%-12s %-12s %-12s %-16s %s\n", $1, $3, $5, $7, $9}'
else
    echo "No EC2 instances found in region $AWS_DEFAULT_REGION."
fi

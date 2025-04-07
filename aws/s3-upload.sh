#!/bin/bash

# Import common functions
source ../utils/common.sh

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <file-or-directory> <s3-bucket> [s3-prefix]"
    echo "Example: $0 ./dist my-bucket website/assets/"
    exit 1
fi

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

FILE_OR_DIR=$1
BUCKET=$2
PREFIX=${3:-""}

# Check if file/directory exists
if [ ! -e "$FILE_OR_DIR" ]; then
    echo "Error: $FILE_OR_DIR does not exist."
    exit 1
fi

# Check if it's a file or directory
if [ -f "$FILE_OR_DIR" ]; then
    echo "Uploading file $FILE_OR_DIR to s3://$BUCKET/$PREFIX$(basename "$FILE_OR_DIR")..."
    aws s3 cp "$FILE_OR_DIR" "s3://$BUCKET/$PREFIX$(basename "$FILE_OR_DIR")"
elif [ -d "$FILE_OR_DIR" ]; then
    echo "Uploading directory $FILE_OR_DIR to s3://$BUCKET/$PREFIX..."
    aws s3 cp --recursive "$FILE_OR_DIR" "s3://$BUCKET/$PREFIX"
fi

if [ $? -eq 0 ]; then
    echo "✅ Upload successful"
    
    # If this is a website, provide the URL
    if aws s3api get-bucket-website --bucket "$BUCKET" >/dev/null 2>&1; then
        echo "Website URL: http://$BUCKET.s3-website-$AWS_DEFAULT_REGION.amazonaws.com/$PREFIX"
    fi
else
    echo "❌ Upload failed"
    exit 1
fi

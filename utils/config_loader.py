#!/usr/bin/env python3

import os
import sys

def load_config(platform):
    """
    Load configuration from the specified platform config file
    
    Args:
        platform (str): Platform name (github, gitlab, aws, vercel)
        
    Returns:
        dict: Configuration key-value pairs
    """
    config_path = os.path.expanduser(f"~/.config/devops-scripts/{platform}.conf")
    
    if not os.path.exists(config_path):
        print(f"Error: {platform} configuration not found.")
        print(f"Please run setup.sh to configure your {platform} credentials.")
        sys.exit(1)
    
    config = {}
    with open(config_path, 'r') as f:
        for line in f:
            if '=' in line:
                key, value = line.strip().split('=', 1)
                config[key] = value
    
    return config

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: config_loader.py <platform>")
        sys.exit(1)
        
    platform = sys.argv[1].lower()
    if platform not in ['github', 'gitlab', 'aws', 'vercel']:
        print(f"Error: Unsupported platform '{platform}'")
        sys.exit(1)
    
    config = load_config(platform)
    for key, value in config.items():
        print(f"{key}={value}")

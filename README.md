# DevOps Scripts Collection

A collection of commonly used scripts for my developer Ops.

## Structure

- `github/` - Scripts for GitHub operations
- `gitlab/` - Scripts for GitLab operations
- `vercel/` - Scripts for Vercel deployments
- `aws/` - Scripts for AWS operations
- `utils/` - Shared utility functions

## Setup

1. Make sure you have required dependencies installed:
   ```bash
   pip install -r requirements.txt
   ```

2. Configure your credentials:
   ```bash
   ./setup.sh
   ```

3. Make scripts executable:
   ```bash
   chmod +x setup.sh
   chmod +x */**.sh
   ```

## Usage

Navigate to the platform directory and run the desired script:

```bash
cd github
./create-repo.sh my-new-repo
```

See individual README files in each directory for specific usage instructions.

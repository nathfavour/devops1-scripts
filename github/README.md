# GitHub Scripts

Common scripts for GitHub operations.

## Available Scripts

- `create-repo.sh`: Create a new GitHub repository
- `list-repos.sh`: List your GitHub repositories
- `create-pr.sh`: Create a pull request
- `clone-all-repos.sh`: Clone all repositories from a user or organization

## Usage Examples

### Create a new repository
```bash
./create-repo.sh my-new-repo "This is a description" private
```

### List your repositories
```bash
./list-repos.sh
```

### Create a pull request
```bash
./create-pr.sh "New feature" "Please review these changes" development main
```

### Clone all repositories
```bash
./clone-all-repos.sh username
```

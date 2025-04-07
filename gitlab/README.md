# GitLab Scripts

Common scripts for GitLab operations.

## Available Scripts

- `create-project.sh`: Create a new GitLab project
- `list-projects.sh`: List your GitLab projects
- `create-merge-request.sh`: Create a merge request
- `clone-all-projects.sh`: Clone all projects from a user or group

## Usage Examples

### Create a new project
```bash
./create-project.sh my-new-project "This is a description" private
```

### List your projects
```bash
./list-projects.sh
```

### Create a merge request
```bash
./create-merge-request.sh "New feature" "Please review these changes" feature-branch main
```

### Clone all projects
```bash
./clone-all-projects.sh your-group
```

# AWS Scripts

Common scripts for AWS operations.

## Available Scripts

- `s3-upload.sh`: Upload files to S3 bucket
- `s3-list.sh`: List S3 buckets or bucket contents
- `ec2-list.sh`: List EC2 instances
- `lambda-deploy.sh`: Deploy a Lambda function

## Usage Examples

### Upload to S3
```bash
./s3-upload.sh ./my-file.zip my-bucket my-prefix/
```

### List S3 buckets
```bash
./s3-list.sh
```

### List S3 bucket contents
```bash
./s3-list.sh my-bucket
```

### List EC2 instances
```bash
./ec2-list.sh
```

### Deploy Lambda function
```bash
./lambda-deploy.sh my-function ./function.zip "nodejs16.x" "index.handler"
```

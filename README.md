# SuperBox Infrastructure

Terraform configuration for SuperBox AWS infrastructure with WebSocket API Gateway.

## Architecture

- **S3 Bucket**: `superbox-mcp-registry` - Stores MCP server metadata as JSON files
- **Lambda Function**: `superbox-mcp-executor` - Runs MCP servers in isolated environment
- **API Gateway WebSocket**: Persistent connections for MCP protocol
- **IAM Role**: Lambda permissions for S3, CloudWatch, and WebSocket management
- **CloudWatch Logs**: Auto-configured with 7-day retention

## Quick Start

### 1. Prerequisites

- AWS Account with programmatic access
- Terraform >= 1.10.0 (or OpenTofu)

### 2. Configure Credentials

Create `terraform.tfvars`:

```hcl
aws_access_key = "your-access-key"
aws_secret_key = "your-secret-key"
aws_region     = "ap-south-1"
project_name   = "superbox"
```

### 3. Package Lambda

```bash
# Windows
.\scripts\package_lambda.ps1

# Linux/macOS
bash scripts/package_lambda.sh
```

### 4. Deploy

```bash
terraform init
terraform apply
```

After deployment, update your `.env` file with the outputs:

```bash
AWS_REGION=ap-south-1
S3_BUCKET_NAME=<s3_bucket_name from output>
WEBSOCKET_URL=<websocket_url from output>
```

## Logging

CloudWatch logs are automatically configured:

- **Log Group**: `/aws/lambda/superbox-mcp-executor` (7-day retention)
- **Permissions**: Managed by IAM module
- **View logs**: `aws logs tail /aws/lambda/superbox-mcp-executor --follow`

## Update Lambda Code

```bash
# Modify aws/lambda.py or aws/proxy.py
bash scripts/package_lambda.sh
terraform apply
```

## Destroy Infrastructure

```bash
terraform destroy
```

resource "aws_s3_bucket" "registry" {
  bucket        = "${var.project_name}-mcp-registry"
  force_destroy = true

  tags = {
    Name        = "${var.project_name}-mcp-registry"
    Description = "MCP server registry storage"
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "registry" {
  bucket = aws_s3_bucket.registry.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "registry" {
  bucket = aws_s3_bucket.registry.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# CORS configuration for web clients
resource "aws_s3_bucket_cors_configuration" "registry" {
  bucket = aws_s3_bucket.registry.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

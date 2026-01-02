output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}

output "s3_bucket_name" {
  description = "S3 bucket name for MCP registry"
  value       = module.s3.bucket_name
}

output "websocket_url" {
  description = "WebSocket URL for MCP connections"
  value       = module.websocket.websocket_url
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = module.lambda.function_name
}

output "lambda_function_arn" {
  description = "Lambda function ARN"
  value       = module.lambda.function_arn
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group for Lambda logs"
  value       = module.lambda.log_group_name
}

output "next_steps" {
  description = "Post-deployment instructions"
  value       = <<-EOT

    Infrastructure deployed successfully!
    Update your .env file with:

    AWS_REGION=${var.aws_region}
    S3_BUCKET_NAME=${module.s3.bucket_name}
    WEBSOCKET_URL=${module.websocket.websocket_url}

  EOT
}

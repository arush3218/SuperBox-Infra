variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of S3 bucket for Lambda access"
  type        = string
}

variable "websocket_api_arn" {
  description = "ARN of WebSocket API Gateway for Lambda to post messages back"
  type        = string
}

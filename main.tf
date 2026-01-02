# S3 bucket for MCP server registry
module "s3" {
  source = "./modules/s3"

  project_name = var.project_name
  aws_region   = var.aws_region
}

# IAM roles and policies for Lambda
module "iam" {
  source = "./modules/iam"

  project_name      = var.project_name
  s3_bucket_arn     = module.s3.bucket_arn
  websocket_api_arn = module.websocket.execution_arn
}

# Lambda function for MCP execution
module "lambda" {
  source = "./modules/lambda"

  project_name       = var.project_name
  aws_region         = var.aws_region
  s3_bucket_name     = module.s3.bucket_name
  execution_role_arn = module.iam.lambda_role_arn
  lambda_runtime     = var.lambda_runtime
  lambda_memory_size = var.lambda_memory_size
  lambda_timeout     = var.lambda_timeout
  log_retention_days = var.log_retention_days
}

# WebSocket API for persistent MCP connections
module "websocket" {
  source = "./modules/websocket"

  project_name         = var.project_name
  lambda_function_name = module.lambda.function_name
  lambda_invoke_arn    = module.lambda.invoke_arn
}

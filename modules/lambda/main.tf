# CloudWatch log group for Lambda
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.project_name}-mcp-executor"
  retention_in_days = var.log_retention_days

  tags = {
    Name = "${var.project_name}-lambda-logs"
  }
}

# Lambda function
resource "aws_lambda_function" "mcp_executor" {
  function_name = "${var.project_name}-mcp-executor"
  role          = var.execution_role_arn
  handler       = "lambda.lambda_handler"
  runtime       = var.lambda_runtime
  filename      = "${path.module}/lambda_payload.zip"
  timeout       = var.lambda_timeout
  memory_size   = var.lambda_memory_size

  source_code_hash = filebase64sha256("${path.module}/lambda_payload.zip")

  depends_on = [
    aws_cloudwatch_log_group.lambda_logs
  ]

  tags = {
    Name = "${var.project_name}-mcp-executor"
  }
}

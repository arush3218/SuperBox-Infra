output "function_arn" {
  description = "Lambda function ARN"
  value       = aws_lambda_function.mcp_executor.arn
}

output "function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.mcp_executor.function_name
}

output "invoke_arn" {
  description = "Lambda function invoke ARN"
  value       = aws_lambda_function.mcp_executor.invoke_arn
}

output "log_group_name" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.lambda_logs.name
}

output "websocket_url" {
  description = "WebSocket URL"
  value       = "${aws_apigatewayv2_api.mcp_websocket.api_endpoint}/production"
}

output "execution_arn" {
  description = "WebSocket API Gateway execution ARN for IAM policies"
  value       = aws_apigatewayv2_api.mcp_websocket.execution_arn
}

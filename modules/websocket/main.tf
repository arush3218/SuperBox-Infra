# WebSocket API for persistent MCP connections
resource "aws_apigatewayv2_api" "mcp_websocket" {
  name                       = "${var.project_name}-mcp-ws"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"

  tags = {
    Name = "${var.project_name}-mcp-ws"
  }
}

# Lambda integration
resource "aws_apigatewayv2_integration" "lambda" {
  api_id             = aws_apigatewayv2_api.mcp_websocket.id
  integration_type   = "AWS_PROXY"
  integration_uri    = var.lambda_invoke_arn
  integration_method = "POST"
}

# Routes: $connect, $disconnect, $default
resource "aws_apigatewayv2_route" "connect" {
  api_id    = aws_apigatewayv2_api.mcp_websocket.id
  route_key = "$connect"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_apigatewayv2_route" "disconnect" {
  api_id    = aws_apigatewayv2_api.mcp_websocket.id
  route_key = "$disconnect"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_apigatewayv2_route" "default" {
  api_id    = aws_apigatewayv2_api.mcp_websocket.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

# Stage
resource "aws_apigatewayv2_stage" "production" {
  api_id      = aws_apigatewayv2_api.mcp_websocket.id
  name        = "production"
  auto_deploy = true

  tags = {
    Name = "${var.project_name}-ws-stage"
  }
}

# Lambda permission
resource "aws_lambda_permission" "websocket" {
  statement_id  = "AllowWebSocketInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.mcp_websocket.execution_arn}/*/*"
}

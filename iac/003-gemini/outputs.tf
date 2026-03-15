output "api_gateway_url" {
  description = "The URL of the API Gateway"
  value       = aws_apigatewayv2_api.http_api.api_endpoint
}

output "api_key_value" {
  description = "The value of the API Key"
  value       = aws_api_gateway_api_key.default.value
  sensitive   = true
}

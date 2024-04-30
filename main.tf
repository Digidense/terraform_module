#Create api gatway
resource "aws_api_gateway_rest_api" "test_rest" {
  name        = "demo-api"
  description = "API Gateway for development"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

#Create api gatway resource
resource "aws_api_gateway_resource" "test_resource" {
  rest_api_id = aws_api_gateway_rest_api.test_rest.id
  parent_id   = aws_api_gateway_rest_api.test_rest.root_resource_id
  path_part   = "test_resource"
}

#Create get method
resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.test_rest.id
  resource_id   = aws_api_gateway_resource.test_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

#API gateway integration
resource "aws_api_gateway_integration" "get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.test_rest.id
  resource_id             = aws_api_gateway_resource.test_resource.id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "GET"
  type                    = "HTTP"
  uri                     = "https://example.com/api"
}

#Create PUT method
resource "aws_api_gateway_method" "put_method" {
  rest_api_id   = aws_api_gateway_rest_api.test_rest.id
  resource_id   = aws_api_gateway_resource.test_resource.id
  http_method   = "PUT"
  authorization = "NONE"
}

#Create POST method
resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.test_rest.id
  resource_id   = aws_api_gateway_resource.test_resource.id
  http_method   = "POST"
  authorization = "NONE"
}
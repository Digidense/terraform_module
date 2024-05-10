# Define API Gateway REST API
resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "demo-api"
  description = "API Gateway for development"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Define API Gateway resource
resource "aws_api_gateway_resource" "test_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "test_resource"
}

# Define Lambda function
resource "aws_lambda_function" "api_lambda" {
  filename      = "example_lambda.zip"
  function_name = "REST_API"
  role          = aws_iam_role.lambda_role.arn
  handler       = "example.handler"
  runtime       = "nodejs20.x"
}

# Define Lambda IAM Role
resource "aws_iam_role" "lambda_role" {
  name               = "example_lambda_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Define Lambda API Authorizer
resource "aws_api_gateway_authorizer" "lambda_authorizer" {
  name                   = "authorizer"
  rest_api_id            = aws_api_gateway_rest_api.rest_api.id
  type                   = "REQUEST"
  authorizer_uri         = aws_lambda_function.api_lambda.invoke_arn
  authorizer_credentials = aws_iam_role.lambda_role.arn
}

# API Gateway GET methods
resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.test_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# API Gateway PUT methods
resource "aws_api_gateway_method" "put_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.test_resource.id
  http_method   = "PUT"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.lambda_authorizer.id
}

# API Gateway POST methods
resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.test_resource.id
  http_method   = "POST"
  authorization = "AWS_IAM"
}

# Integrate Lambda with API Gateway
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.test_resource.id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api_lambda.invoke_arn
}

# Integrate Lambda with API Gateway
resource "aws_api_gateway_integration" "put_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.test_resource.id
  http_method             = aws_api_gateway_method.put_method.http_method
  integration_http_method = "PUT"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api_lambda.invoke_arn
}

# Integrate Lambda with API Gateway
resource "aws_api_gateway_integration" "get_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.test_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api_lambda.invoke_arn
}

# Deploy API Gateway
resource "aws_api_gateway_deployment" "api_deploy" {
  depends_on  = [aws_api_gateway_integration.lambda_integration, aws_api_gateway_integration.put_lambda_integration, aws_api_gateway_integration.get_lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = "Development"
}


# Cloudwatch
resource "aws_cloudwatch_log_group" "api_gateway_logs" {
  name = "api-gateway/demo-api-access-logs"
}

# Define Lambda Cloud_Watch Role
resource "aws_iam_role" "api_gateway_log_role" {
  name = "api_gateway_log_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "apigateway.amazonaws.com"
      },
      "Action" : "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "api_gateway_log_role_attachment" {
  role       = aws_iam_role.api_gateway_log_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}






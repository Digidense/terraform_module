# Define API Gateway REST API
resource "aws_api_gateway_rest_api" "virtual_api" {
  name        = "virtual_api"
  description = "API Gateway for development"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Define API Gateway resource
resource "aws_api_gateway_resource" "virtual_resource" {
  rest_api_id = aws_api_gateway_rest_api.virtual_api.id
  parent_id   = aws_api_gateway_rest_api.virtual_api.root_resource_id
  path_part   = "virtual_resource"
}

# Define Lambda function
resource "aws_lambda_function" "api_lambda" {
  filename      = var.lambda_zip_file
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  tracing_config {
    mode = "Active"
  }
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
  rest_api_id            = aws_api_gateway_rest_api.virtual_api.id
  type                   = "REQUEST"
  authorizer_uri         = aws_lambda_function.api_lambda.invoke_arn
  authorizer_credentials = aws_iam_role.lambda_role.arn
}

# API Gateway GET methods
resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.virtual_api.id
  resource_id   = aws_api_gateway_resource.virtual_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# API Gateway PUT methods
resource "aws_api_gateway_method" "put_method" {
  rest_api_id   = aws_api_gateway_rest_api.virtual_api.id
  resource_id   = aws_api_gateway_resource.virtual_resource.id
  http_method   = "PUT"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.lambda_authorizer.id
}

# API Gateway POST methods
resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.virtual_api.id
  resource_id   = aws_api_gateway_resource.virtual_resource.id
  http_method   = "POST"
  authorization = "AWS_IAM"
}

# Integrate Lambda with API Gateway
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.virtual_api.id
  resource_id             = aws_api_gateway_resource.virtual_resource.id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api_lambda.invoke_arn
}

# Integrate Lambda with API Gateway
resource "aws_api_gateway_integration" "put_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.virtual_api.id
  resource_id             = aws_api_gateway_resource.virtual_resource.id
  http_method             = aws_api_gateway_method.put_method.http_method
  integration_http_method = "PUT"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api_lambda.invoke_arn
}

# Integrate Lambda with API Gateway
resource "aws_api_gateway_integration" "get_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.virtual_api.id
  resource_id             = aws_api_gateway_resource.virtual_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api_lambda.invoke_arn
}

# Deploy API Gateway
resource "aws_api_gateway_deployment" "api_deploy" {
  depends_on  = [aws_api_gateway_integration.lambda_integration, aws_api_gateway_integration.put_lambda_integration, aws_api_gateway_integration.get_lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.virtual_api.id
  stage_name  = "Development"
}

# Define API Gateway Stage
resource "aws_api_gateway_stage" "api_stage" {
  stage_name    = "DEV"
  rest_api_id   = aws_api_gateway_rest_api.virtual_api.id
  deployment_id = aws_api_gateway_deployment.api_deploy.id
}

# API Gateway log_role
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

# role attachment
resource "aws_iam_role_policy_attachment" "api_gateway_log_role_attachment" {
  role       = aws_iam_role.api_gateway_log_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

#Enable the cloudwatch logs
resource "aws_api_gateway_method_settings" "api_settings" {
  rest_api_id   = aws_api_gateway_rest_api.virtual_api.id
  stage_name  = aws_api_gateway_stage.api_stage.stage_name
  method_path = "*/*"
  settings {
    logging_level = "INFO"
    data_trace_enabled = true
    metrics_enabled = true
  }
}




variable "lambda_zip_file" {
  description = "Path to the Lambda zip file"
  type        = string
  default     = "example_lambda.zip"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "REST_API"
}

variable "lambda_handler" {
  description = "Handler function for the Lambda"
  type        = string
  default     = "example.handler"
}

variable "lambda_runtime" {
  description = "Runtime for the Lambda function"
  type        = string
  default     = "nodejs20.x"
}

variable "ingress_nlb" {
  description = "Pass the Loadbalence uri"
  type = string
  default = "http://adfb1356f7d4d452db2f9c7da59a3a09-2e7fd284c7346cbb.elb.us-east-1.amazonaws.com"
}

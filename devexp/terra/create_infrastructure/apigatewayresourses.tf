/*
This plan creates AWS API Gateway interface to invoke lambda functions using api token 
*/

resource "aws_api_gateway_rest_api" "api" {
  name = "${var.project_name}-lambda-beanstalk-api"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "resource_b" {
  path_part   = var.api_1_path
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_resource" "resource_f" {
  path_part   = var.api_2_path
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_method" "method_b" {
  rest_api_id      = aws_api_gateway_rest_api.api.id
  resource_id      = aws_api_gateway_resource.resource_b.id
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = true
}
resource "aws_api_gateway_method" "method_f" {
  rest_api_id      = aws_api_gateway_rest_api.api.id
  resource_id      = aws_api_gateway_resource.resource_f.id
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "integration_1_b" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource_b.id
  http_method             = aws_api_gateway_method.method_b.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.lambda_back.invoke_arn
}
resource "aws_api_gateway_integration" "integration_1_f" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource_f.id
  http_method             = aws_api_gateway_method.method_f.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.lambda_front.invoke_arn
}

resource "aws_api_gateway_method_response" "response_200_b" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource_b.id
  http_method = aws_api_gateway_method.method_b.http_method
  status_code = "200"
}
resource "aws_api_gateway_method_response" "response_200_f" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource_f.id
  http_method = aws_api_gateway_method.method_f.http_method
  status_code = "200"
}
resource "aws_api_gateway_integration_response" "integration_response_1_b" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource_b.id
  http_method = aws_api_gateway_method.method_b.http_method
  status_code = aws_api_gateway_method_response.response_200_b.status_code
  depends_on = [aws_api_gateway_integration.integration_1_b]
}
resource "aws_api_gateway_integration_response" "integration_response_1_f" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource_f.id
  http_method = aws_api_gateway_method.method_f.http_method
  status_code = aws_api_gateway_method_response.response_200_f.status_code
  depends_on = [aws_api_gateway_integration.integration_1_f]
}


resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [aws_api_gateway_integration_response.integration_response_1_b,
                aws_api_gateway_integration_response.integration_response_1_f]
  rest_api_id = aws_api_gateway_rest_api.api.id  
}

resource "aws_api_gateway_usage_plan" "api_usage_plan" {
  name         = "Api usage plan-${aws_api_gateway_rest_api.api.id}"
  description  = "${aws_api_gateway_rest_api.api.id}-plan"
  
  api_stages {
    api_id = aws_api_gateway_rest_api.api.id
    stage  = aws_api_gateway_stage.dev_stage.stage_name
  } 

  quota_settings {
    limit  = 10000    
    period = "MONTH"
  }

  throttle_settings {
    burst_limit = 2
    rate_limit  = 5
  }
  depends_on = [aws_api_gateway_stage.dev_stage,
  aws_api_gateway_rest_api.api]
}

resource "aws_api_gateway_stage" "dev_stage" {
  stage_name    = "dev"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.remo.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.api_usage_plan.id
}
resource "aws_api_gateway_api_key" "remo" {
  name = "remo"
}

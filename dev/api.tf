resource "aws_api_gateway_rest_api" "main" {
  name        = "TerraformBootcampApi-${local.env}"
  description = "Terraform Bootcamp API Gateway"
}

resource "aws_api_gateway_resource" "proxy" {
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "{proxy+}"
  rest_api_id = aws_api_gateway_rest_api.main.id
}

resource "aws_api_gateway_method" "proxy" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_resource.proxy.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_method.proxy.resource_id
  http_method = aws_api_gateway_method.proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.random.invoke_arn
}

//  PROXY ROOT
resource "aws_api_gateway_method" "proxy_root" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = aws_api_gateway_rest_api.main.root_resource_id
  rest_api_id   = aws_api_gateway_rest_api.main.id
}


resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_method.proxy_root.resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.random.invoke_arn
}


resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = "main"

  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.lambda_root
  ]
}


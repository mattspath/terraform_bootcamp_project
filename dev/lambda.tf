data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
data "aws_iam_policy_document" "random" {
  statement {
    actions   = ["dynamodb:*"]
    resources = [aws_dynamodb_table.main.arn]
  }
  statement {
    actions   = ["s3:*"]
    resources = [aws_s3_bucket.main.arn]
  }
  statement {
    actions   = ["logs:*"]
    resources = ["${aws_cloudwatch_log_group.random.arn}:*"]
  }
}


resource "aws_iam_role" "random" {
  name               = "${local.random_lambda_name}_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "random" {
  name   = "${local.random_lambda_name}_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.random.json
}

resource "aws_iam_role_policy_attachment" "random" {
  role       = aws_iam_role.random.name
  policy_arn = aws_iam_policy.random.arn
}

# data "archive_file" "lambda" {
#   type        = "zip"
#   source_file = "lambda.js"
#   output_path = "lambda_function_payload.zip"
# }


resource "aws_lambda_function" "random" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  function_name = local.random_lambda_name
  role          = aws_iam_role.random.arn
  handler       = "app.handler"
  runtime       = "python3.8"
  memory_size   = 256
  timeout       = 10
  s3_bucket     = aws_s3_bucket.main.id
  s3_key        = aws_s3_bucket_object.main.id


  environment {
    variables = {
      DYNAMO_TABLE_NAME = aws_dynamodb_table.main.id
    }
  }
  depends_on = [
    aws_cloudwatch_log_group.random
  ]




  tags = merge(local.tags, {
    Name = local.random_lambda_name
  })


}

resource "aws_cloudwatch_log_group" "random" {
  name              = "/aws/lambda/${local.random_lambda_name}"
  retention_in_days = 14
}


resource "aws_lambda_permission" "api" {
    statement_id = "AllowGatewayInvoke"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.random.function_name
    principal = "apigateway.amazonaws.com"
    source_arn = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}
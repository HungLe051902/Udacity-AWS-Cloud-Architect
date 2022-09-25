provider "aws" {
  region = "us-east-1"
}

data "archive_file" "lambda_zip" {
    type = "zip"
    source_file = "greet_lambda.py"
    output_path = var.lambda_output_path
}


resource "aws_iam_role" "lambda_role_for_exec" {
  name = "lambda_role_for_exec"

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

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 7
}

resource "aws_iam_policy" "lambda_logs_policy" {
  name        = "lambda_logs_policy"
  path        = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs_policy" {
  role       = aws_iam_role.lambda_role_for_exec.name
  policy_arn = aws_iam_policy.lambda_logs_policy.arn
}

resource "aws_lambda_function" "greeting_lambda" {
  function_name = var.lambda_function_name
  filename = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  handler = var.lambda_handler
  runtime = var.runtime
  role = aws_iam_role.lambda_role_for_exec.arn

  environment{
      variables = {
          greeting = "Hello World!"
      }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_logs_policy, aws_cloudwatch_log_group.lambda_log_group]
}
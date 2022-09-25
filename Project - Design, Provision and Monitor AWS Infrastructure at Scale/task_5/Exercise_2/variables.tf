# TODO: Define the variable for aws_region
variable "lambda_function_name" {
  type = string
  default = "greet_lambda"
}

variable "runtime" {
  type = string
  default = "python3.8"
}

variable "lambda_output_path" {
  type = string
  default = "output.zip"
}

variable "lambda_handler" {
  type = string
  default = "greet_lambda.lambda_handler"
}
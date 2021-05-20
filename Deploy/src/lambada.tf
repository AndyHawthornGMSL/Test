data "archive_file" "trade_api" {
  type        = "zip"
  source_dir  = "${path.module}/../app/TradeApi"
  output_path = "${path.module}/../app/TradeApi.zip"
}


data "aws_iam_policy_document" "assume-role-policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name                = "${var.env}-lambda-role"
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
  assume_role_policy  = data.aws_iam_policy_document.assume-role-policy.json

  tags = merge(local.common_tags, {
    Name = "${var.env}-lambda-role"
  })
}

resource "aws_lambda_function" "trade_api" {
  filename         = data.archive_file.trade_api.output_path
  function_name    = "${var.env}-trades"
  role             = aws_iam_role.lambda_role.arn
  source_code_hash = filebase64sha256(data.archive_file.trade_api.output_path)
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  tags             = local.common_tags
}
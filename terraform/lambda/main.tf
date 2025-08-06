module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "Send-alb-logs-to-splunk"
  description   = "Send alb logs from s3 to splunk"
  handler       = "lambda.lambda_handler"
  runtime       = "python3.12"
  create_role   = false
  lambda_role   = module.lambda_role.iam_role_arn
  publish       = true
  source_path   = "./lambda.py"
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.lambda_function_arn
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.alb_logs_bucket}"
}

resource "aws_s3_bucket_notification" "alb_log_trigger" {
  bucket = var.alb_logs_bucket

  lambda_function {
    lambda_function_arn = module.lambda_function.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}


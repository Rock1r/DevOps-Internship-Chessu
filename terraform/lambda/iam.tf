resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  path        = "/"
  description = "lambda policy for sending ALB logs to Splunk"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["s3:GetObject", "s3:ListBucket"],
        "Resource" : ["arn:aws:s3:::chessu-alb-logs/*",
        "arn:aws:s3:::chessu-alb-logs"]
      },
      {
        "Effect" : "Allow",
        "Action" : ["ssm:GetParameter"],
        "Resource" : "arn:aws:ssm:us-east-1:122627526984:parameter/splunk/hec_token_alb"
      },
      {
        "Effect" : "Allow",
        "Action" : ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
        "Resource" : ["arn:aws:logs:us-east-1:122627526984:log-group:/aws/lambda/Send-alb-logs-to-splunk:*"]
      }
    ]
    }
  )
}


module "lambda_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  create_role = true

  role_name         = "LambdaS3AlbLogReader"
  role_requires_mfa = false

  custom_role_policy_arns = [
    aws_iam_policy.lambda_policy.arn
  ]
  number_of_custom_role_policy_arns = 1
  trusted_role_services = [
    "lambda.amazonaws.com"
  ]
}
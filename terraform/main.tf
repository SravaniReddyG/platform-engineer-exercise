provider "aws" {
  region = "us-east-2"
}

data "aws_caller_identity" "current" {}

# EC2 instance
# Fetch latest Amazon Linux 2 AMI dynamically
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "api_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  tags = {
    Name = "api-server"
  }
}


# SNS topic
resource "aws_sns_topic" "alerts" {
  name = "performance-alerts"
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "restart-ec2-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

# Least privilege-ish policy
resource "aws_iam_policy" "lambda_policy" {
  name = "restart-ec2-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["ec2:RebootInstances"]
        Resource = "arn:aws:ec2:us-east-2:${data.aws_caller_identity.current.account_id}:instance/${aws_instance.api_server.id}"
      },
      {
        Effect = "Allow"
        Action = ["sns:Publish"]
        Resource = aws_sns_topic.alerts.arn
      },
      {
        Effect = "Allow"
        Action = ["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Lambda function (needs lambda.zip in this same folder)
resource "aws_lambda_function" "restart_ec2" {
  function_name = "restart-ec2-on-alert-tf"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"

  filename         = "${path.module}/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda.zip")

  environment {
    variables = {
      INSTANCE_ID   = aws_instance.api_server.id
      SNS_TOPIC_ARN = aws_sns_topic.alerts.arn
    }
  }
}

# Lambda Function URL (Sumo will call this)
resource "aws_lambda_function_url" "sumo_webhook" {
  function_name      = aws_lambda_function.restart_ec2.function_name
  authorization_type = "NONE"
}

# Allow public invoke via Function URL
resource "aws_lambda_permission" "allow_function_url_invoke" {
  statement_id           = "AllowFunctionUrlInvoke"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.restart_ec2.function_name
  principal              = "*"
  function_url_auth_type = "NONE"
}

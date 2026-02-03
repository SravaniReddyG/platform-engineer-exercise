output "ec2_instance_id" {
  value = aws_instance.api_server.id
}

output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}

output "lambda_name" {
  value = aws_lambda_function.restart_ec2.function_name
}

output "lambda_function_url" {
  value = aws_lambda_function_url.sumo_webhook.function_url
}

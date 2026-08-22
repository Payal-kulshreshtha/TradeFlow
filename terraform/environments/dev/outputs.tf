output "lambda_execution_role_arn" {
  description = "Lambda Execution role ARN"
  value       = module.iam.lambda_execution_role_arn
}

output "extract_data_lambda_arn" {
  description = "Extract Data Lambda ARN"
  value       = module.extract_data_lambda.function_arn
}

output "extract_data_lambda_name" {
  description = "Extract Data Lambda name"
  value       = module.extract_data_lambda.function_name
}

output "trade_data_bucket_name" {
  description = "Trade data s3 bucket"
  value       = module.trade_data_bucket.bucket_name
}

output "process_data_lambda_arn" {
  description = "Process Data Lambda ARN"
  value       = module.process_data_lambda.function_arn
}

output "process_data_lambda_name" {
  description = "Process Data Lambda name"
  value       = module.process_data_lambda.function_name
}

output "tradeflow_state_machine_arn" {
  description = "TradeFlow step function state machine arn"
  value       = module.trade_flow_state_machine.state_machine_arn
}

output "tradeflow_state_machine_name" {
  description = "TradeFlow step function state machine name"
  value       = module.trade_flow_state_machine.state_machine_name
}

output "sns_topic_arn" {
  description = "SNS Topic Arn"
  value = module.tradeflow_notification.topic_arn
}

output "sns_topic_name" {
  description = "SNS Topic Name"
  value = module.tradeflow_notification.topic_name
}
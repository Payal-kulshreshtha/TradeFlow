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
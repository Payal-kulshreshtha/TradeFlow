module "iam" {
  source       = "../../modules/iam"
  project_name = var.project_name
  environment  = var.environment
}

module "extract_data_lambda" {
  source        = "../../modules/lambda"
  function_name = "${var.project_name}-${var.environment}-extract-data"
  source_path   = "../../../lambdas/extract_data"
  role_arn      = module.iam.lambda_execution_role_arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  timeout       = 60
  memory_size   = 256
  environment_variables = {
    API_URL   = var.trade_api_url
    S3_BUCKET = module.trade_data_bucket.bucket_name
  }
}

module "trade_data_bucket" {
  source = "../../modules/s3"

  bucket_name = "${var.project_name}-${var.environment}-trade-data"
  environment = var.environment
}
module "iam" {
  source       = "../../modules/iam"
  project_name = var.project_name
  environment  = var.environment

  sns_topic_arn = module.tradeflow_notification.topic_arn
}

module "extract_data_lambda" {
  source        = "../../modules/lambda"
  function_name = "${var.project_name}-${var.environment}-extract-data"
  source_path   = "../../../lambdas/extract_data"
  role_arn      = module.iam.lambda_execution_role_arn
  handler       = var.handler
  runtime       = var.runtime
  timeout       = var.timeout
  memory_size   = var.memory_size

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

module "process_data_lambda" {
  source        = "../../modules/lambda"
  function_name = "${var.project_name}-${var.environment}-process-data"
  source_path   = "../../../lambdas/process_data"
  role_arn      = module.iam.lambda_execution_role_arn
  handler       = var.handler
  runtime       = var.runtime
  timeout       = var.timeout
  memory_size   = var.memory_size

  environment_variables = {
    S3_BUCKET = module.trade_data_bucket.bucket_name
  }
}


module "step_function_iam" {
  source       = "../../modules/step_function_iam"
  project_name = var.project_name
  environment  = var.environment
  lambda_arns = [
    module.extract_data_lambda.function_arn,
    module.process_data_lambda.function_arn,
    module.notify_lambda.function_arn
  ]
}

module "trade_flow_state_machine" {
  source             = "../../modules/step_function"
  state_machine_name = "${var.project_name}-${var.environment}-pipeline"

  role_arn = module.step_function_iam.step_function_execution_role_arn
  definition = jsonencode({
    Comment = "TradeFlow data processing pipeline"
    StartAt = "NotifyStarted"

    States = {
      NotifyStarted = {
        Type     = "Task"
        Resource = "arn:aws:states:::lambda:invoke"

        Parameters = {
          FunctionName = module.notify_lambda.function_arn

          Payload = {
            notification_type = "PROCESS_STARTED"
            message           = "TradeFlow processing has started."
            "execution_id.$"  = "$$.Execution.Id"
          }
        }

        ResultPath = "$.notification_result"

        Next = "ExtractData"
      }

      ExtractData = {
        Type     = "Task"
        Resource = "arn:aws:states:::lambda:invoke"

        Parameters = {
          FunctionName = module.extract_data_lambda.function_arn
          Payload      = {}
        }
        ResultSelector = {
          "status.$" = "$.Payload.status"
          "bucket.$" = "$.Payload.bucket"
          "key.$"    = "$.Payload.key"
        }
        ResultPath = "$.extract_result"
        Next       = "ProcessData"
      }

      ProcessData = {
        Type     = "Task"
        Resource = "arn:aws:states:::lambda:invoke"


        Parameters = {
          FunctionName = module.process_data_lambda.function_arn

          Payload = {
            "bucket.$" = "$.extract_result.bucket"
            "key.$"    = "$.extract_result.key"
          }
        }

        ResultSelector = {
          "status.$"        = "$.Payload.status"
          "bucket.$"        = "$.Payload.bucket"
          "raw_key.$"       = "$.Payload.raw_key"
          "processed_key.$" = "$.Payload.processed_key"
          "record_count.$"  = "$.Payload.record_count"
        }
        ResultPath = "$.process_result"
        End        = true
      }
    }
  })
}

module "tradeflow_notification" {
  source     = "../../modules/sns"
  topic_name = "${var.project_name}-${var.environment}-notifications"
}

module "notify_lambda" {
  source        = "../../modules/lambda"
  function_name = "${var.project_name}-${var.environment}-notify"
  source_path   = "../../../lambdas/notify"

  role_arn = module.iam.lambda_execution_role_arn

  handler     = var.handler
  runtime     = var.runtime
  timeout     = var.timeout
  memory_size = var.memory_size

  environment_variables = {
    SNS_TOPIC_ARN = module.tradeflow_notification.topic_arn
  }
}
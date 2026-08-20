variable "source_path" {
  description = "Path of Source code"
  type        = string
}
variable "function_name" {
  description = "Lambda function name"
  type        = string
}
variable "role_arn" {
  description = "IAM role ARN for Lambda"
  type        = string
}
variable "handler" {
  description = "Lambda handler"
  type        = string
  default     = "lambda_function.lambda_handler"
}
variable "runtime" {
  description = "Lambda Runtime"
  type        = string
  default     = "python3.12"
}
variable "timeout" {
  description = "Lambda timeout in secs"
  type        = number
  default     = 60
}
variable "memory_size" {
  description = "Lambda Size in MB"
  type        = number
  default     = 256
}
variable "environment_variables" {
  description = "Environment variables for Lambda"
  type        = map(string)
  default     = {}
}
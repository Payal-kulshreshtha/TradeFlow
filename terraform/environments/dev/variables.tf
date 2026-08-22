variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "trade_api_url" {
  description = "Dummy tradde API endpoint"
  type        = string
}

variable "handler" {
  default = "lambda_function.lambda_handler"
  type    = string
}

variable "runtime" {
  default = "python3.12"
  type    = string
}
variable "timeout" {
  default = 60
  type    = number
}

variable "memory_size" {
  default = 256
  type    = number
}
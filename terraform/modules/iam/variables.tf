variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "environment" {
  description = "Deployed Environemnt"
  type        = string
}

variable "sns_topic_arn" {
  description = "SNS Topic ARN"
  type        = string
  default     = null
}
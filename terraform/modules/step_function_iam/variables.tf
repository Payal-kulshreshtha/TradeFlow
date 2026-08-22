variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "environment" {
  description = "Deployed Environemnt"
  type        = string
}

variable "lambda_arns" {
  description = "Lambda ARNs Step FUnctions can invoke"
  type        = list(string)
}
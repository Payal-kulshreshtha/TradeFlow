variable "state_machine_name" {
  description = "Name of step function"
  type        = string
}

variable "definition" {
  description = "Step function state machine definition"
  type        = string
}

variable "role_arn" {
  description = "IAM role ARM for step function"
  type        = string
}
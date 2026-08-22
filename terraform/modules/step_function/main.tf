resource "aws_sfn_state_machine" "this" {
  name       = var.state_machine_name
  role_arn   = var.role_arn
  definition = var.definition

  type = "STANDARD"
}
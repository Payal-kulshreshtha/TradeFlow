output "state_machine_arn" {
  description = "Step Functions state machine ARN"
  value       = aws_sfn_state_machine.this.arn
}

output "state_machine_name" {
  description = "Name of Step Function state machine"
  value       = aws_sfn_state_machine.this.name
}
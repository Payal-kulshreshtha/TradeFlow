output "step_function_execution_role_arn" {
  description = "Step Functions execution role arn"
  value       = aws_iam_role.this.arn
}
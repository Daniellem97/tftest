output "iam_role_arn" {
  value       = aws_iam_role.example_role.arn
  description = "The ARN of the IAM role"
}

output "iam_policy_name" {
  value       = aws_iam_role_policy.example_policy.name
  description = "The name of the IAM policy attached to the role"
}

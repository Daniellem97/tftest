output "iam_role_arn" {
  value       = aws_iam_role.example_role.arn
  description = "The ARN of the IAM role"
}

output "iam_policy_name" {
  value       = aws_iam_policy_attachment.admin_access.name
  description = "The name of the IAM policy attached to the role"
}

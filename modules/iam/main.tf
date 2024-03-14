resource "aws_iam_role" "testing_importiam" {
  name = "testingimportiam"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "admin_access" {
  name       = "admin-access-attachment"
  roles      = [aws_iam_role.testing_importiam.name]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

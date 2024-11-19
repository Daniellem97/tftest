resource "aws_vpc" "mtc_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "dev23"
  }
}

resource "aws_vpc" "mtc_vpc6" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "dev213"
  }
}
resource "aws_vpc" "mtc_vpc1" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "dev213"
  }
}
resource "aws_vpc" "mtc_vpc2" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "dev213"
  }
}
resource "aws_vpc" "mtc_vpc3" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "dev213"
  }
}
resource "aws_vpc" "mtc_vpc4" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "dev213"
  }
}
resource "aws_vpc" "mtc_vpc5" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "dev213"
  }
}
resource "aws_vpc" "mtc_vpc7" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "dev213"
  }
}
resource "aws_vpc" "mtc_vpc8" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "dev213"
  }
}
resource "aws_vpc" "mtc_vpc9" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "dev213"
  }
}
resource "aws_vpc" "mtc_vpc10" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "dev213"
  }
}

resource "aws_route" "default_route2" {
  route_table_id         = aws_route_table.mtc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mtc_internet_gateway.id
}
moved {
  from = aws_route.default_route3
  to   = aws_route.default_route2
}

resource "aws_subnet" "mtc_public_subnet" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Repository = "new2"
  }
}

resource "aws_internet_gateway" "mtc_internet_gateway" {
  vpc_id = aws_vpc.mtc_vpc.id
  tags = {
    Name = "mtc_igw"
  }
}


resource "aws_route_table" "mtc_public_rt" {
  vpc_id = aws_vpc.mtc_vpc.id
  tags = {
    Name = "dev_public_rt"
  }
}
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.mtc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mtc_internet_gateway.id
}

resource "aws_route_table_association" "mtc_public_assoc" {
  subnet_id      = aws_subnet.mtc_public_subnet.id
  route_table_id = aws_route_table.mtc_public_rt.id
}

resource "aws_security_group" "mtc_sg" {
  name        = "public_sg"
  description = "public security group"
  vpc_id      = aws_vpc.mtc_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "spacelift_repository"{
} 

output "projects" {
  value = {
    test1 = {
      id      = "test1name"
      id_full = "full_id"
      number  = "12345"
    },
    test2 = {
      id      = "test2name"
      id_full = "full_id"
      number  = "67890"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Change to your preferred region
}

resource "aws_s3_bucket" "codebuild_artifacts" {
  bucket = "codebuild-artifacts-bucket-unique-name" # Replace with a unique bucket name
  acl    = "private"
}

resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "codebuild_policy" {
  role = aws_iam_role.codebuild_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:*"],
        Resource = [
          aws_s3_bucket.codebuild_artifacts.arn,
          "${aws_s3_bucket.codebuild_artifacts.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_codebuild_project" "example" {
  name          = "example-codebuild-project"
  description   = "Example AWS CodeBuild Project"
  build_timeout = 10 # in minutes
  service_role  = aws_iam_role.codebuild_role.arn

  source {
    type = "NO_SOURCE" # No primary source; buildspec will be inline
  }

  artifacts {
    type      = "S3"
    location  = aws_s3_bucket.codebuild_artifacts.bucket
    packaging = "ZIP"
    path      = "codebuild-output"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0" # Replace with the latest image
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
  }

  buildspec = <<EOF
version: 0.2

phases:
  install:
    runtime-versions:
      nodejs: 16
    commands:
      - echo "Installing dependencies..."
      - npm install
  pre_build:
    commands:
      - echo "Running pre-build steps..."
      - npm run lint
  build:
    commands:
      - echo "Building the project..."
      - npm run build
  post_build:
    commands:
      - echo "Running post-build steps..."
      - npm run test
      - echo "Build complete!"

artifacts:
  files:
    - "**/*"
  discard-paths: yes
EOF
}


  #  command = templatefile("${var.host_os}-ssh-config.tpl", {
  #    hostname = self.public_ip,
  #    user     = "ubuntu",
  #  identityfile = "~/.ssh/mtckey" })
  #  interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  #}


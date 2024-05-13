data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

data "terraform_remote_state" "demo-stack-state" {
  backend = "remote"

  config = {
    hostname     = "spacelift.io"
    organization = "daniellem97"

    workspaces = {
      name = "demo-stack"
    }
  }
}

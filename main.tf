module "terraform-default-multimodule" {
  source  = "spacelift.io/daniellem97/terraform-default-multimodule/default"
  version = "0.3.10"

  # Optional inputs 
  # version_number = string
}


resource "aws_vpc" "mtc_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "dev23"
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
    Name = "mtc_igw2"
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

resource "aws_cloudfront_function" "example" {
  name    = "example-request-handler" # Contains "request"
  runtime = "cloudfront-js-1.0"       # Current CloudFront function runtime

  code = <<-EOT
    function handler(event) {
        var request = event.request;
        var headers = request.headers;

        // Add your logic here, including checking or manipulating `headers['true-client-ip']`
        if (headers['true-client-ip']) {
            console.log("True-Client-IP: " + headers['true-client-ip'].value);
        } else {
            console.log("True-Client-IP header is not present.");
        }

        return request;
    }
  EOT

  comment = "CloudFront function handling request logic."
}
  #  command = templatefile("${var.host_os}-ssh-config.tpl", {
  #    hostname = self.public_ip,
  #    user     = "ubuntu",
  #  identityfile = "~/.ssh/mtckey" })
  #  interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  #}


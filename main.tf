resource "aws_vpc" "mtc_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "dev21"
  }
}

resource "aws_subnet" "mtc_public_subnet" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "dev-public"
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

 resource "aws_key_pair" "mtc_auth" {
  key_name   = "mtckey2"
  public_key = file("mtckey.pub")
}

resource "aws_instance" "dev_node" {
    instance_type = "t2.micro"
    ami = data.aws_ami.server_ami.id
    key_name = aws_key_pair.mtc_auth.id 
    vpc_security_group_ids = [aws_security_group.mtc_sg.id]
    subnet_id = aws_subnet.mtc_public_subnet.id
    user_data = file("userdata.tpl")
    tags = {
    Name = "ExampleInstance"
    Environment = "Dev"                        
  }
}

resource "aws_s3_bucket" "testing_imports" {
  # You can initially leave the configuration block empty or configure it to match your bucket's settings.
  bucket = "testingimportsl" # This name must exactly match your bucket's name in AWS.
}


resource "aws_s3_bucket" "oihfosdhfousf" {
  bucket = "my-public-bucket-name" # Ensure this name is unique across all existing bucket names in AWS
  acl    = "public-read"

  tags = {
    Name        = "oihfosdhfousf"
    Environment = "Public"
  }
}

  #  command = templatefile("${var.host_os}-ssh-config.tpl", {
  #    hostname = self.public_ip,
  #    user     = "ubuntu",
  #  identityfile = "~/.ssh/mtckey" })
  #  interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  #}


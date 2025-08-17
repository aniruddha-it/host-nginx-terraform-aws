

# EC2 instance for nginx setup

resource "aws_instance" "web" {
  ami = var.ec2-server.ami
  instance_type = var.ec2-server.instance_type
  user_data = var.ec2_user_data
  subnet_id = aws_subnet.main["public-subnet"].id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  iam_instance_profile = data.aws_iam_instance_profile.name.name

  tags = {
    Name = var.ec2-server.ec2_name
  }
}

# data "aws_iam_role" "ec2-role" {
#   name = "ec2-s3-log"
# }

data "aws_iam_instance_profile" "name" {
  name = "ec2-s3-log"
  
}



resource "aws_security_group" "ec2_sg" {
  
  vpc_id = aws_vpc.main.id
 dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  

  tags = {
    Name = "web-sg"
  }
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_config.cidr_block

tags = {
  name = var.vpc_config.vpc_name
}
}


resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main.id
  for_each = var.sub_config

  cidr_block = each.value.cidr_block
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}



locals {
  public_sub={
    # key={} if public is true in sub_config
    for key , config in var.sub_config : key => config if config.public
  }
}

locals {
  private_sub={
    # key={} if public is true in sub_config
    for key , config in var.sub_config : key => config if !config.public
  }
}

# IGW For public subnet
resource "aws_internet_gateway" "vpc-igw" {
  vpc_id = aws_vpc.main.id
  count = length(local.public_sub) > 0 ? 1 : 0

}

resource "aws_route_table" "vpc-route" {
  vpc_id = aws_vpc.main.id
  count = length(local.public_sub) > 0 ? 1 : 0
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-igw[0].id
  }
}

resource "aws_route_table_association" "route_link" {
  for_each = local.public_sub

  subnet_id = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.vpc-route[0].id

}

resource "aws_s3_bucket" "s3-name" {
  bucket = var.s3-bucket
}

resource "aws_s3_bucket_public_access_block" "s3-pub" {
  bucket = aws_s3_bucket.s3-name.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "s3-policy" {
  bucket = aws_s3_bucket.s3-name.id

  policy = jsonencode ({
    Version = "2012-10-17",
    Statement = [
        {
            Sid = "PublicReadGetObject",
            Effect = "Allow",
            Principal = "*",
            Action = "s3:GetObject"
            Resource = "arn:aws:s3:::my-cloud-s3-abcd1425/*"
        }
    ]
})
}

resource "aws_s3_bucket_website_configuration" "s3-web" {
  bucket = aws_s3_bucket.s3-name.id

  index_document {
    suffix = var.s3-suffix
  }
}

resource "aws_s3_object" "s3-object" {
  bucket = aws_s3_bucket.s3-name.bucket

  for_each = var.s3-object

  source = each.value.source
  key = each.value.key
  content_type = each.value.content_type
}
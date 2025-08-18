provider "aws" {
  region = "eu-north-1"
}

module "server" {
  source = "./project"

  ec2-server = {
    ami = "ami-0b4fbd58a32e7ef15"
    instance_type = "t3.micro"
    ec2_name = "virtual-server"
    

  }

   ingress_rules = [ 
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
]

 egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]


vpc_config = {
  cidr_block = "10.0.0.0/16"
  vpc_name = "my-vpc"

}


sub_config = {
  public-subnet = {
        cidr_block = "10.0.0.0/24"
        az = "eu-north-1a"
        public = true
    }
    private-subnet = {
        cidr_block = "10.0.1.0/24"
        az = "eu-north-1a"
    }

  }

  s3-bucket = "my-cloud-s3-efgh1425"
    

  s3-pub-access = {
    my-cloud-s3-abcd1425 = {
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
    }
  }


s3-suffix = "index.html"


s3-object = {
  s3_html = {
  source = "project/index.html"
  key = "index.html"
  content_type = "text/html"
  }
  s3_css = {
  source = "project/design.css"
  key = "design.css"
  content_type = "text/css"
  }

}


}


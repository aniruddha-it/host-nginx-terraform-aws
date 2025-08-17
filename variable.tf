variable "ec2-server" {
  #Giving ami id and instance type
    type = object({
        ami = string
        instance_type = string
        ec2_name = string
    })
}

variable "ec2_user_data" {
  #For giving script that install nginx
  type = string
  default = <<-EOF
            #!bin/bash
            sudo apt install nginx -y
            sudo systemctl start nginx
            
            EOF
}

variable "ingress_rules" {
   type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    
  }))
  default = [
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
}

# Egress rule (allow all)
variable "egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = optional(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
}

variable "vpc_config" {
  description = "To get the cidr and name of VPC from user"
  type = object({
    cidr_block = string
    vpc_name = string
  })

  
}


 variable "sub_config" {
    description = "Get the data of CIDR and AZ for the subnets"
   type = map(object({
     cidr_block = string
     az = string
     public = optional(bool,false)
   }))

}

variable "s3-bucket" {
  type = string

}

variable "s3-pub-access" {
  type = map(object({
     
  block_public_acls       = optional(bool,false)
  block_public_policy     = optional(bool,false)
  ignore_public_acls      = optional(bool,false)
  restrict_public_buckets = optional(bool,false)
  }))
}

# variable "s3-policy" {

#   type = object({
#     Version   = string
#     Statement = list(object({
#       Sid       = string
#       Effect    = string
#       Principal = any
#       Action    = string
#       Resource  = string
#     }))
#   })

#   default = ({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid       = "PublicReadGetObject"
#         Effect    = "Allow"
#         Principal = "*"
#         Action    = "s3:GetObject"
#         Resource  = "arn:aws:s3:::my-cloud-s3-1425abcd/*"
#       }
#     ]
#   })
# }



variable "s3-suffix" {
  type = string
  default = "index.html"
}

variable "s3-object" {
  type = map(object({
    source = string
    key = string
    content_type = string  
    }))
}
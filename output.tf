output "vpc-id" {
  value = aws_vpc.main.id
}

locals {
#   to format the subnet IDs which may be multiple in format of subnet_name={id=  ,az=  }
  public-sub-out = {
    for key, config in local.public_sub : key => {
        subnet-id = aws_subnet.main[key].id
        az = aws_subnet.main[key].availability_zone

    }
  }
  private-sub-out = {
    for key, config in local.private_sub : key => {
        subnet-id = aws_subnet.main[key].id
        az = aws_subnet.main[key].availability_zone
  }
}
}


output "public-subnet-id" {
  value=local.public-sub-out
}

output "private-subnet-id" {
  value=local.private-sub-out
}
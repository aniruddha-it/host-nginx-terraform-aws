🚀 AWS NGINX Deployment with Terraform
This project provisions an AWS EC2 instance running NGINX, using Terraform with a myself created modular structure. It includes all necessary networking components like a VPC, public subnet, internet gateway, and a security group allowing SSH and HTTP traffic.

📦 Features

✅ VPC with public subnet

✅ Internet Gateway and Route Table

✅ Security Group for SSH (22) and HTTP (80)

✅ EC2 instance with Ubuntu 22.04

✅ User data script to install NGINX

✅ Modular Terraform structure

⚙️ Requirements

Terraform
AWS CLI
Bash Script
AWS credentials configured (aws configure)
An existing EC2 Key Pair (key_name must match)
🚀 Usage

1. Clone the Repo
bash git clone https://github.com/your-username/aws-terraform-nginx.git cd aws-terraform-nginx

Initialize Terraform bash Copy Edit terraform init

Plan the Changes bash Copy Edit terraform plan

Apply the Infrastructure bash Copy Edit terraform apply

🧾 Example 

terraform.tfvars hcl Copy Edit key_name = "your-ec2-keypair-name" instance_type = "t2.micro" 🔒 .gitignore (included) The .gitignore file excludes:

.terraform/ folder

*.tfstate, *.tfstate.backup

terraform.tfvars

terraform.lock.hcl

📌 Notes The EC2 instance is created in the ap-south-1 (Mumbai) region.

Make sure the AMI ID is valid for your chosen region.

Always commit your .terraform.lock.hcl file for reproducible builds.

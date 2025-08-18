#!/bin/bash
            
sudo yum update
sudo amazon-linux-extras install nginx1 -y
sudo yum install -y nginx

sudo systemctl start nginx
sudo systemctl enable nginx

yum install -y unzip curl

sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo yum install unzip
unzip awscliv2.zip
sudo ./aws/install

rm -rf /usr/share/nginx/html/*

# Download full site content from S3 (HTML, CSS, JS, images, etc.)
sudo aws s3 sync s3://${var.s3-bucket} /usr/share/nginx/html
            


# Set proper permissions
sudo chown -R nginx:nginx /usr/share/nginx/html
sudo chmod -R 755 /usr/share/nginx/html


sudo systemctl start nginx
sudo systemctl enable nginx





                        EOF
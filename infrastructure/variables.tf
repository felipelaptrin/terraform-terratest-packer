variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "network_ip" {
  description = "CIDR block of the VPC Network"
  type        = string
  default     = "172.20.0.0"
}

variable "s3_bucket_name" {
  description = "Name of the the s3 bucket that will be created"
  type        = string
  default     = "dummy-s3-bucket-flat"
}

variable "ec2_ami" {
  description = "AMI to be used in EC2 instances. Defaults to one eligible for free tier."
  type        = string
  default     = "ami-09d56f8956ab235b3"
}

variable "ec2_type" {
  description = "EC2 instance type. Defaults to one eligible for free tier."
  type        = string
  default     = "t2.micro"
}

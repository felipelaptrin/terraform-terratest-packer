## Networking (VPC)
resource "aws_vpc" "this" {
  cidr_block = local.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-new"
  }
}

resource "aws_subnet" "this" {
  count = 3

  vpc_id            = aws_vpc.this.id
  cidr_block        = "${local.vpc_first_two_octets}.${tonumber(local.vpc_third_octet) + count.index}.${local.vpc_fourth_octet}/26"
  availability_zone = data.aws_availability_zones.this.names[count.index]

  tags = {
    Name = "public-subnet-vpc-new-${count.index}"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "default-vpc-new-rt"
  }
}

## S3
resource "aws_s3_bucket" "this" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

## EC2
resource "aws_instance" "dummy" {
  ami           = var.ec2_ami
  instance_type = var.ec2_type
  subnet_id     = aws_subnet.this[0].id
}

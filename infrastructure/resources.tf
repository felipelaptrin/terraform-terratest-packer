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

resource "aws_security_group" "alb" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "cluster" {
  name        = "allow_alb_traffic"
  description = "Allow ALB traffic to port 8000"
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "HTTP"
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
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

## EC2 Dummy
resource "aws_instance" "dummy" {
  ami           = var.ec2_ami
  instance_type = var.ec2_type
  subnet_id     = aws_subnet.this[0].id
}

## EC2 Cluster
resource "aws_instance" "cluster" {
  count           = 2
  ami             = data.aws_ami.static_webapp.id
  instance_type   = var.ec2_type
  subnet_id       = aws_subnet.this[count.index].id
  security_groups = [aws_security_group.cluster.id]

  tags = {
    Name = "Flugel - Cluster"
  }
}

resource "aws_lb_target_group" "this" {
  name     = "tf-static-webapp"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id

  health_check {
    path = "/health"
  }
}

resource "aws_lb_target_group_attachment" "this" {
  count            = 2
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.cluster[count.index].id
  port             = 8000
}

resource "aws_alb" "this" {
  name               = "alb-static-webapp"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [for subnet in aws_subnet.this : subnet.id]
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_alb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

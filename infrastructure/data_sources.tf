data "aws_availability_zones" "this" {
  state = "available"
  filter {
    name   = "region-name"
    values = [var.aws_region]
  }

}

data "aws_ami" "static_webapp" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["basic-static-file-*"]
  }
}

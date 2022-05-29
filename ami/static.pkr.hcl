packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "static" {
  ami_name      = "basic-static-file-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-09d56f8956ab235b3"
  ssh_username  = "ubuntu"
}

build {
  sources = [
    "amazon-ebs.static"
  ]

  provisioner "file" {
    source      = "../static_webapp.zip"
    destination = "/tmp/static_webapp.zip/"
  }

  provisioner "file" {
    source      = "./static.service"
    destination = "/tmp/static.service"
  }

  provisioner "shell" {
    script = "./build.sh"
  }

}

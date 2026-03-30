packer {
  required_plugins {
    amazon = {
      version = "~> 1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "version" {
  type    = string
  default = "1.0.3"
}

data "amazon-ami" "ubuntu-focal-west" {
  region = "eu-west-1"
  filters = {
    name = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
  }
  most_recent = true
  owners      = ["099720109477"]
}

source "amazon-ebs" "basic-example-west" {
  region = "eu-west-1"
  source_ami     = data.amazon-ami.ubuntu-focal-west.id
  instance_type  = "t3.small"
  ssh_username   = "ubuntu"
  ssh_agent_auth = false
  ami_name       = "packer_AWS_{{timestamp}}_v${var.version}"
}

build {
  hcp_packer_registry {
    bucket_name = "base-image"
    description = "Base Image"

    bucket_labels = {
      "owner"          = "platform-team"
      "os"             = "Ubuntu",
      "ubuntu-version" = "Focal 20.04",
      "architecture"   = "x86_64",
    }

    build_labels = {
      "build-time"   = timestamp()
      "build-source" = basename(path.cwd)
    }
  }
  provisioner "shell" {
    inline = [
      "sudo rm -rf /var/lib/apt/lists/*", # Pulisce la cache corrotta
      "sudo apt-get clean", 
      "sudo apt-get update -y",
      "sudo apt-get install -y curl gpg python3-pip",
      "sudo pip3 install --upgrade pip setuptools",
      "bash -c \"$(curl -sSL https://install.mondoo.com/sh)\"",
      "cnquery sbom --output cyclonedx-json --output-target /tmp/sbom_cyclonedx.json",
    ]
  }

  provisioner "hcp-sbom" {
    source      = "/tmp/sbom_cyclonedx.json"
    destination = "./sbom"
    sbom_name   = "sbom-cyclonedx"
  }


  sources = [
    "source.amazon-ebs.basic-example-west"
  ]
}
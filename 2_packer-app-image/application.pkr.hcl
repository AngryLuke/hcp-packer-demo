variable "welcome_message" {
  type    = string
  default = "Welcome to the Packer-built Application Server Production v3.1.0!"
}

data "hcp-packer-version" "ubuntu" {
  bucket_name  = "base-image"
  channel_name = "production"
}

data "hcp-packer-artifact" "ubuntu-west" {
  bucket_name         = "base-image"
  version_fingerprint = data.hcp-packer-version.ubuntu.fingerprint
  platform            = "aws"
  region              = "eu-west-1"
}


source "amazon-ebs" "application-west" {
  ami_name = "packer_AWS_{{timestamp}}"

  region         = "eu-west-1"
  source_ami     = data.hcp-packer-artifact.ubuntu-west.external_identifier
  instance_type  = "t3.small"
  ssh_username   = "ubuntu"
  ssh_agent_auth = false

  tags = {
    Name = "learn-packer-application"
  }
}


build {
  hcp_packer_registry {
    bucket_name = "app"
    description = <<EOT
Application image built on top of the base image.
    EOT
    bucket_labels = {
      "foo-version"  = "3.4.0",
      "foo"          = "bar",
      "owner"        = "app-engineering-team",
    }
    # QUESTE sono le etichette che Terraform legge per il singolo ARTEFATTO
    build_labels = {
      "build-time"   = timestamp(),
      "architecture" = "x86_64",
    }
  }
  
  provisioner "shell" {
    inline = [
      "sudo rm -rf /var/lib/apt/lists/*", # Pulisce la cache corrotta
      "sudo apt-get clean",
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx",
      "sudo bash -c 'cat > /var/www/html/index.html <<HTML\n<!DOCTYPE html>\n<html>\n<head><title>Welcome</title></head>\n<body>\n<h1>${var.welcome_message}</h1>\n</body>\n</html>\nHTML'",
      "sudo systemctl enable nginx",

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
    "source.amazon-ebs.application-west"
  ]
}
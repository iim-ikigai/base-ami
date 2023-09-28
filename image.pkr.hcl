variable "docker_image" {
  type    = string
  default = "ubuntu:jammy"
}

variable "ami_name" {
  type    = string
  default = "${env("AMI_NAME")}"
}

packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
    ansible = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

source "docker" "ubuntu" {
  image  = "ubuntu:jammy"
  commit = true
}


build {
  name    = "learn-packer"
  sources = ["source.docker.ubuntu"]

  provisioner "shell" {
    script =  "scripts/export.sh"
  }
  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
      "TZ=Etc/UTC",
      "section2=true",
      "AMI_NAME=${var.ami_name}"
    ]
    inline = [
      "echo Adding file to Docker Container",
      "echo \"FOO is $FOO\" > example.txt",
      "printenv",
      "whoami"
    ]
  }

  
  provisioner "shell" {
    script =  "scripts/install-python.sh"
  }

  
 

  post-processor "docker-tag" {
    repository = "learn-packer"
    tags       = ["ubuntu-xenial", "packer-rocks"]
    only       = ["docker.ubuntu"]
  }



}
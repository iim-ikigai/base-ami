variable "docker_image" {
  type    = string
  default = "ubuntu:xenial"
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
  image  = "ubuntu:xenial"
  commit = true
}


build {
  name = "learn-packer"
  sources = ["source.docker.ubuntu"]
  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo Adding file to Docker Container",
      "echo \"FOO is $FOO\" > example.txt",
    ]
  }


  provisioner "ansible" {
    command           = "ANSIBLE_FORCE_COLOR=1"
    playbook_file     = "ansible/playbook-test.yaml"
  }

  provisioner "shell" {
    inline = ["echo Running ${var.docker_image} Docker image."]
  }
 


  post-processor "docker-tag" {
    repository = "learn-packer"
    tags       = ["ubuntu-xenial", "packer-rocks"]
    only       = ["docker.ubuntu"]
  }



}
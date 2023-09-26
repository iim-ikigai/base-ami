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

  provisioner "shell" {
    script       = "scripts/install-ansible.sh"
    pause_before = "10s"
    timeout      = "10s"
  }

  provisioner "ansible" {
    playbook_file = "./ansible/playbook-test.yaml"
    sftp_command  = "/usr/bin/false"
    use_sftp      = false
  }

  provisioner "shell" {
    inline = ["echo Running ${var.docker_image} Docker image."]
  }
  provisioner "shell" {
    script       = "scripts/cleanup.sh"
    pause_before = "10s"
    timeout      = "10s"
  }


  post-processor "docker-tag" {
    repository = "learn-packer"
    tags       = ["ubuntu-xenial", "packer-rocks"]
    only       = ["docker.ubuntu"]
  }



}
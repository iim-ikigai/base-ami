packer {
    required_plugins {
      amazon = {
        version = ">= 0.0.2"
        source  = "github.com/hashicorp/amazon"
      }
      ansible = {
        version = ">= 1.1.0"
        source  = "github.com/hashicorp/ansible"
      }
    }
  }

  variable "ami_name" {
    type    = string
    default = "${env("AMI_NAME")}"
  }
  
  
  source "amazon-ebs" "ubuntu" {
    ami_name      = "learn-packer-linux-aws-2"
    instance_type = "t1.micro"
    region        = "us-west-2"
    source_ami_filter {
      filters = {
        architecture        = "x86_64"
        name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
        root-device-type    = "ebs"
        virtualization-type = "hvm"
      }
      most_recent = true
      owners      = ["099720109477"]
    }
    ssh_username = "ubuntu"
  }
  
  build {
    name    = "learn-packer-2"
    sources = [ "source.amazon-ebs.ubuntu" ]
    
    
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
      ]
    }

    provisioner "shell" {
      script =  "scripts/py.sh"
    }

    provisioner "shell" {
      script =  "scripts/export.sh"
    }
    provisioner "ansible" {
      playbook_file = "ansible/playbook-test.yaml"
      galaxy_file   = "ansible/requirements.yaml"
    }
  
    // provisioner "shell" {
    //   inline = ["python3 -h"]
    // }
  
  }
  
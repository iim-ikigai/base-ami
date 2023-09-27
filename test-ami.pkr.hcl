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
  
  source "amazon-ebs" "ubuntu" {
    ami_name      = "learn-packer-linux-aws"
    instance_type = "t2.micro"
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
    name    = "learn-packer"
    sources = [
      "source.amazon-ebs.ubuntu"
    ]
    

    provisioner "shell" {
      script =  "scripts/install-python.sh"
    }

    provisioner "shell" {
      script =  "scripts/export.sh"
    }
  


    // provisioner "ansible-local" {
    //   playbook_file = "ansible/playbook-test.yaml"
    //   galaxy_file   = "ansible/requirements.yaml"
    // }
  
    provisioner "shell" {
      inline = ["python3 -h"]
    }
  
  }
  
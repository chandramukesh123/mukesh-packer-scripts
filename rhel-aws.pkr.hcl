packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}


source "amazon-ebs" "rhel9-image" {
  ami_name        = "mukesh-rhel9-image"
  ami_description = "Custom RHEL 7 AMI with 8 GB RAM and 10 GB storage"
  instance_type   = "t2.micro"
  region          = "us-east-2"
  ssh_username    = "ec2-user"
  source_ami = "ami-0aa8fc2422063977a"
  #source_ami_filter {
  #  filters = {
   #   name                = "RHEL-9.0.0_HVM-20220513-x86_64"
    #  virtualization-type = "hvm"
     # root-device-type    = "ebs"
    #}
    #most-recent = true
    #owners      = ["992382822158"]
  

  ami_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = 10
    volume_type = "gp2"
  }
}


build {
  sources = [
    "source.amazon-ebs.rhel9-image"
  ]

  # Define the provisioner for configuring the instance
  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo yum install nginx -y",
      "sudo systemctl enable nginx.service"
    ]
  }
}


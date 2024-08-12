packer {
  required_plugins {
    vmware = {
      version = "~> 1"
      source = "github.com/hashicorp/vmware"
    }
  }
}

# Define the Packer template
source "vsphere-iso" "rhel7" {
  vsphere_server = "mukesh-vmware-vsphere-server"
  user           = "mukesh"
  password       = "chandra"
  allow_unverified_ssl = true

  datastore       = "your-datastore"
  cluster         = "your-cluster"
  network         = "your-network"
  folder          = "your-folder"
  template        = "path-to-your-rhel7-template"

  boot_command = [
    "<enter><wait>",
    "root<enter>",
    "password<enter>", # Change this to your root password or use appropriate method
    "<wait>",
    "yum update -y<enter>",
    "shutdown -h now<enter>"
  ]

  boot_wait = "5s"

  disk_controller_type = "pvscsi"

  network_interface {
    network = "your-network"
    adapter_type = "e1000"
  }

  disk {
    size             = 10
    eagerly_scrub    = false
    delete_provisioned_disk_on_destroy = true
    type             = "thin"
  }

  cpu {
    cores = 2
  }

  memory {
    size = 2048 # 2GB of RAM
  }
  
  ssh_username = "root"
  ssh_password = "your-root-password"
  ssh_timeout = "30m"

  post-processor "vagrant" {
    keep_input_artifact = false
  }
}

# Define the build configuration
build {
  sources = [
    "source.vsphere-iso.rhel7"
  ]

  provisioner "shell" {
    inline = [
      "yum update",
      "yum install ngnix -y"
    ]
  }
}

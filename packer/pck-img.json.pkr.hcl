# This file was autogenerated by the 'packer hcl2_upgrade' command. We
# recommend double checking that everything is correct before going forward. We
# also recommend treating this file as disposable. The HCL2 blocks in this
# file can be moved to other files. For example, the variable blocks could be
# moved to their own 'variables.pkr.hcl' file, etc. Those files need to be
# suffixed with '.pkr.hcl' to be visible to Packer. To use multiple files at
# once they also need to be in the same folder. 'packer inspect folder/'
# will describe to you what is in that folder.

# Avoid mixing go templating calls ( for example ```{{ upper(`string`) }}``` )
# and HCL2 calls (for example '${ var.string_value_example }' ). They won't be
# executed together and the outcome will be unknown.

# See https://www.packer.io/docs/templates/hcl_templates/blocks/packer for more info
packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = "~> 1"
    }
  }
}

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "googlecompute" "autogenerated_1" {
  image_family        = "custom-images"
  image_name          = "custom-image-with-db"
  network             = "projects/cloud-nw-dev/global/networks/default"
  project_id          = "cloud-nw-dev"
  source_image_family = "centos-stream-8"
  ssh_username        = "root"
  subnetwork          = "default"
  use_os_login        = true
  zone                = "us-east1-c"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.googlecompute.autogenerated_1"]

  provisioner "shell" {
    inline = [
      "echo Adding file to Docker Container",
      ls -l
    ]
  }
  provisioner "shell" {
    script = "./group.sh"
  }

  provisioner "shell" {
    script = "./install_db.sh"
  }

  provisioner "file" {
    destination = "/tmp/csye6225.service"
    source      = "./csye6225.service"
  }

  provisioner "shell" {
    script = "./server.sh"
  }

  post-processor "manifest" {
    output = "image-manifest.json"
  }
}

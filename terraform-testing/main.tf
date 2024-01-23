#   export TERRAFORM_LIBVIRT_TEST_DOMAIN_TYPE="qemu"
provider "libvirt" {
   uri = "qemu:///system"
}

resource "libvirt_volume" "opnsense-qcow2" {
  name = "opnsense-qcow2"
  pool = "default"
  source = var.opnsense_img_url
  format = "qcow2"
}

data "template_file" "user_data" {
  template = file("${path.module}/config/cloud_init.yml")
}

data "template_file" "network_config" {
  template = file("${path.module}/config/network_config.yml")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  user_data      = data.template_file.user_data.rendered
  pool           = "default"
}

resource "libvirt_network" "internal-network" {
  name = "cyber-range-LAN"
  mode = "nat"
  addresses = ["10.10.10.10/24"]
  dns {
    enabled = true
  }
  dhcp {
    enabled = true
  }
}

# testing with a self created default network
# delete this and change network_interface { networ_name = "default" } to use previous config
resource "libvirt_network" "default_network" {
    name = "default_network"
    mode = "nat"
    addresses = ["192.168.122.1/24"]
    dns {
      enabled = true
    }
    dhcp {
      enabled = true
    }
}


resource "libvirt_domain" "domain-opnsense" {
  name   = var.vm_hostname
  memory = "2048"
  vcpu   = 2
  machine = "q35"
  
  xml {
    xslt = file("cdrom-model.xsl")
  }

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_name   = libvirt_network.default_network.name
  }

  network_interface {
    network_name = libvirt_network.internal-network.name
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.opnsense-qcow2.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

}
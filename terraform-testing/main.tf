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
resource "libvirt_volume" "disk" {
  name = "large-disk"
  pool = "default"
  format = "qcow2"
  size = 10000000000
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
resource "libvirt_network" "default_network" {
    name = "default_network"
    mode = "nat"
    addresses = ["198.168.122.2/24"]
    dns {
      enabled = true
    }
    dhcp {
      enabled = true
    }
}
resource "libvirt_network" "vmbr0-net" {
  name = "vmbro0-net"
  mode = "none"
}
resource "libvirt_network" "vmbr1-net" {
  name = "vmbro1-net"
  mode = "none"
}
resource "libvirt_domain" "domain-opnsense" {
  name   = var.vm_hostname
  memory = "2048"
  vcpu   = 2
  machine = "q35"
  
  xml {
    xslt = file("${path.module}/config/cdrom-model.xsl")
  }
  cloudinit = libvirt_cloudinit_disk.commoninit.id
  network_interface {
    network_name   = libvirt_network.default_network.name
  }
  network_interface {
    network_name = libvirt_network.vmbr0-net.name
  }
  network_interface {
    network_name = libvirt_network.vmbr1-net.name
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
  disk {
    volume_id = libvirt_volume.disk.id
  }
  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

#   export TERRAFORM_LIBVIRT_TEST_DOMAIN_TYPE="qemu"
variable "VM_USER" {
  default = "developer"
  type    = string
}

variable "VM_HOSTNAME" {
  default = "pfSense"
  type    = string
}

variable "VM_IMG_FORMAT" {
  default = "qcow2"
  type    = string
}

variable "VM_CIDR_RANGE" {
  default = "10.10.10.10/24"
  type    = string
}

# instance the provider
provider "libvirt" {
  uri = "qemu:///system"
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
  vars = {
    VM_USER = var.VM_USER
  }
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config.cfg")
}

resource "libvirt_pool" "vm" {
  name = "${var.VM_HOSTNAME}_kvm_pool_1"
  type = "dir"
  path = "/tmp/pfSense_pool_storage"
}

resource "libvirt_volume" "vm" {
  name   = "${var.VM_HOSTNAME}_volume.${var.VM_IMG_FORMAT}"
  pool   = libvirt_pool.vm.name
  source = var.ubuntu_18_img_url
  format = var.VM_IMG_FORMAT
}

resource "libvirt_network" "vm_public_network" {
  name      = "${var.VM_HOSTNAME}_network"
  mode      = "bridge"
  bridge    = "br0"
  domain    = "${var.VM_HOSTNAME}.local"
  addresses = ["${var.VM_CIDR_RANGE}"]
  dhcp {
    enabled = true
  }
  dns {
    enabled = true
  }
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  name           = "${var.VM_HOSTNAME}_cloudinit.iso"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.vm.name
}

resource "libvirt_domain" "vm" {
  name       = var.VM_HOSTNAME
  memory     = "1024"
  vcpu       = 1
  qemu_agent = true

  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  network_interface {
    network_name   = "default"
    wait_for_lease = true
    hostname       = var.vm_hostname
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
    volume_id = libvirt_volume.vm.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

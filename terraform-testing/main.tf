provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "opnsense-qcow2" {
  name = "opnsense-qcow2"
  pool = "default"
  source = var.ubuntu_18_img_url
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

resource "libvirt_domain" "domain-opnsense" {
  name   = var.vm_hostname
  memory = "2048"
  vcpu   = 2
  machine = "pc-q35-3.1"
  
  xml {
    xslt = file("cdrom-model.xsl")
  }

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_name   = "default"
    wait_for_lease = true
    # hostname       = var.vm_hostname
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
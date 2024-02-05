resource "libvirt_volume" "kali-qcow2" {
  name   = "kali-qcow2"
  pool   = "default"
  source = var.kali_img_url
  format = "qcow2"
}

data "template_file" "kali-user_data" {
  template = file("${path.module}/config/kali_cloud_init.yml")
}

data "template_file" "kali-network_config" {
  template = file("${path.module}/config/network_config.yml")
}

resource "libvirt_cloudinit_disk" "kali-commoninit" {
  name      = "kali-commoninit.iso"
  user_data = data.template_file.kali-user_data.rendered
  pool      = "default"
}

resource "libvirt_domain" "kali-domain" {
  name       = "kali-domain"
  memory     = "2048"
  vcpu       = 2
  machine    = "q35"
  depends_on = [libvirt_network.default_network]
  xml {
    xslt = file("${path.module}/config/cdrom-model.xsl")
  }

  cloudinit = libvirt_cloudinit_disk.kali-commoninit.id

  network_interface {
    network_name = libvirt_network.vmbr0-net.name
  }

  network_interface {
    network_name = libvirt_network.vmbr1-net.name
  }


  filesystem {
    # I have no idea why this has to be so complicated for specifying a relative path but it has something to do with the different OS with host and target vm :D
    source   = pathexpand(abspath("${path.module}/utils"))
    target   = "tmp"
    readonly = false
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
    volume_id = libvirt_volume.kali-qcow2.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}




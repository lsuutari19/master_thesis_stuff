variable "libvirt_disk_path" {
  description = "path for libvirt pool"
  default     = "/opt/kvm/pool1"
}

variable "ubuntu_18_img_url" {
  description = "opnsense image"
  # default     = "http://cloud-images.ubuntu.com/releases/bionic/release-20191008/ubuntu-18.04-server-cloudimg-amd64.img"
  # default = "pfSense.img"
  # default = "https://atxfiles.netgate.com/mirror/downloads/pfSense-CE-2.7.2-RELEASE-amd64.iso.gz"
  default = "opensense.qcow2"
}

variable "vm_hostname" {
  description = "vm hostname"
  default     = "kvm-opnsense"
}

variable "ssh_username" {
  description = "the ssh user to use"
  default     = "ssh-opnsense"
}

variable "ssh_private_key" {
  description = "the private key to use"
  default     = "~/.ssh/id_rsa"
}

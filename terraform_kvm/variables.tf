variable "libvirt_disk_path" {
  description = "path for libvirt pool"
  default     = "/opt/kvm/pfSense_pool"
}

variable "ubuntu_18_img_url" {
  # description = "pfSense image"
  default = "https://cloud-images.ubuntu.com/releases/bionic/release/ubuntu-18.04-server-cloudimg-amd64.img"
}

variable "vm_hostname" {
  description = "vm hostname"
  default     = "pfSense"
}

variable "ssh_username" {
  description = "the ssh user to use"
  default     = "ubuntu"
}

variable "ssh_private_key" {
  description = "the private key to use"
  default     = "~/.ssh/id_rsa"
}

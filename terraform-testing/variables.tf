variable "libvirt_disk_path" {
  description = "path for libvirt pool"
  default     = "/opt/kvm/pool1"
}

variable "opnsense_img_url" {
  description = "opnsense image"
  default = "opnsense.qcow2"
}

variable "ubuntu_img_url" {
  description = "ubuntu image"
  default     = "lubuntu.iso"
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

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
  # default = "https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2"
  default = "https://cloud-images.ubuntu.com/releases/bionic/release/ubuntu-18.04-server-cloudimg-amd64.img"
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

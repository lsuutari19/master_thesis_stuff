variable "libvirt_disk_path" {
  description = "path for libvirt pool"
  default     = "/opt/kvm/pool1"
}

variable "opnsense_img_url" {
  description = "opnsense image"
  # default = "opnsense.qcow2"
  # default = "pfSense-CE-2.7.2-RELEASE-amd64.iso"
  default = "images/router_pfsense.qcow2"
}

variable "ubuntu_img_url" {
  description = "ubuntu image"
  # default = "https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2"
  default = "https://cloud-images.ubuntu.com/releases/bionic/release/ubuntu-18.04-server-cloudimg-amd64.img"
  # default = "images/ubuntu-desktop.iso"
}

variable "kali_img_url" {
  description = "kali desktop image"
  default = "images/kali-linux-2023.4-qemu-amd64.qcow2"
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

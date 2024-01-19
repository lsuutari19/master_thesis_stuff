# Installation instructions

## Install and setup libvirtd

Start and enable libvirtd
    sudo systemctl start libvirtd
    sudo systemctl enable libvirtd

## Install terraform
Follow specific instructions for your system

https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

### verify terraform is accessible and the CLI works
which terraform
terraform --version


### install virt-manager for VM accessibility
sudo apt-get install virt-manager


### install qemu and verify the installation
qemu-system-x86_64 --version

### download the required opnsense image
https://github.com/maurice-w/opnsense-vm-images/releases/tag/23.7.11

(I am currently using the OPNsense-23.7.11-ufs-efi-vm-amd64.qcow2.bz2)

Make sure the variables.tf variable matches path to the file:

(this looks for the image in the directory where the main.tf is)
variable "opnsense_img_url" {
  description = "opnsense image"
  default = "opnsense.qcow2"
}

### Terraform magic
terraform init
terraform apply
export TERRAFORM_LIBVIRT_TEST_DOMAIN_TYPE="qemu"

### If you want to deploy the docker containers you need to have docker engine running

# Installation instructions

This installation instruction is designed for Ubuntu operating system.

## Install and setup libvirtd and necessary packages for UEFI virtualization
```
sudo apt update
sudo apt-get install qemu-kvm libvirt-daemon-system virt-top libguestfs-tools ovmf
sudo adduser $USER libvirt
sudo usermod -aG libvirt $(whoami)
```

Start and enable libvirtd
```
sudo systemctl start libvirtd
sudo systemctl enable libvirtd
```

## Install terraform
Follow specific instructions for your system

https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

### verify terraform is accessible and the CLI works
```
which terraform
terraform --version
```


### install virt-manager for VM accessibility
```
sudo apt-get install virt-install virt-viewer
sudo apt-get install virt-manager
```

### install qemu and verify the installation
https://www.qemu.org/download/#linux
```
qemu-system-x86_64 --version
```
### download the required opnsense image
https://github.com/maurice-w/opnsense-vm-images/releases/tag/23.7.11

(I am currently using the OPNsense-23.7.11-ufs-efi-vm-amd64.qcow2.bz2)

Move the image to terraform-testing directory and rename it opnsense.qcow2

### Install mkisofs
```
sudo apt-get install -y mkisofs
```

### Install xsltproc 
```
sudo apt-get install xsltproc
```

### Initialize default storage pool if it hasn't been created by libvirt

```
sudo virsh pool-define /dev/stdin <<EOF
<pool type='dir'>
  <name>default</name>
  <target>
    <path>$PWD/images</path>
  </target>
</pool>
EOF

sudo virsh pool-start default
sudo virsh pool-autostart default
```

### Configure user permisions for libvirt to storage pool
```
sudo chown -R $(whoami):libvirt ~/images
sudo systemctl restart libvirtd
```


### Terraform magic
```
export TERRAFORM_LIBVIRT_TEST_DOMAIN_TYPE="qemu"
terraform init
terraform apply
```

### If you want to deploy the docker containers you need to have docker engine running
(Otherwise just change the extension of docker.tf from tf to txt)


## Issues & fixes:
```
problem:
Error: Error defining libvirt domain: virError(Code=67, Domain=10, Message='unsupported configuration: Emulator '/usr/bin/qemu-system-x86_64' does not support virt type 'kvm'')

solution 1:
try export TERRAFORM_LIBVIRT_TEST_DOMAIN_TYPE="qemu"

solution2:
enable virtualization in the host system
```

```
problem:
pool default not found

solution:
sudo virsh pool-define /dev/stdin <<EOF
<pool type='dir'>
  <name>default</name>
  <target>
    <path>/var/lib/libvirt/images</path>
  </target>
</pool>
EOF

sudo virsh pool-start default
sudo virsh pool-autostart default
```

```
problem: VM is stuck at "booting from hard disk..."
solution: Verify that you have installed the OVMF package to allow for UEFI virtualization
```


# Installation instructions

## Install and setup libvirtd
```
sudo apt update
sudo apt install qemu-kvm libvirt-daemon-system virt-top libguestfs-tools
sudo adduser $USER libvirt
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
```

### Install mkisofs
```
sudo apt-get install -y mkisofs
```

### 

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


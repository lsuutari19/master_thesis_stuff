#!/bin/bash

echo "Starting cleanup..."

# destroy the VMs
sudo virsh destroy kvm-opnsense
sudo virsh undefine kvm-opnsense --remove-all-storage

sudo virsh destroy ubuntu-domain
sudo virsh undefine ubuntu-domain --remove-all-storage

result=$(sudo virsh list --all)
if [[ $result == *kvm-opnsense* || $result == *ubuntu-domain* ]]; then
    echo "VM domains could not be destroyed."
    exit 1;
else
    echo "VM domains have been destroyed."
fi

# Command to destroy the virtual network
sudo virsh net-destroy default_network
sudo virsh net-undefine default_network
sudo virsh net-destroy cyber-range-LAN
sudo virsh net-undefine cyber-range-LAN

result=$(sudo virsh net-list --all)
if [[ $result == *default_network* || $result == *cyber-range-LAN* ]]; then
    echo "Virtual networks could not be destroyed."
    exit 1;
else
    echo "VM networks have been destroyed."
fi

# Command to destroy the pool storage
sudo virsh pool-destroy default
sudo virsh pool-undefine default

result=$(sudo virsh pool-list --all)
if [[ $result == *default* ]]; then
    echo "VM pool storages could not be destroyed."
    exit 1;
else
    echo "VM pool storages have been destroyed."
fi


# Command to delete volumes
sudo virsh vol-delete /var/lib/libvirt/images/commoninit.iso
sudo virsh vol-delete /var/lib/libvirt/images/opnsense-qcow2
sudo virsh vol-delete /var/lib/libvirt/images/ubuntu-commoninit.iso
sudo virsh vol-delete /var/lib/libvirt/images/ubuntu-qcow2

result=$(sudo virsh vol-list --pool default)
if [[ $result == *default* ]]; then
    echo "VM volumes could not be deleted."
    exit 1;
else
    echo "VM volumes have been destroyed."
fi

# Command to delete ISO file
# sudo virsh vol-delete /tmp/terraform-provider-libvirt-pool/vm_cloudinit.iso

rm terraform.tfstate
rm terraform.tfstate.backup

echo "Cleanup completed."
exit 0

#!/bin/bash

virsh destroy pfSense
virsh undefine pfSense --remove-all-storage

# Command to destroy network
virsh net-destroy pfSense_network
virsh net-destroy vm_test_network
virsh net-destroy vm_network

# Command to destroy pool
virsh pool-destroy pfSense_kvm_pool1

# Command to undefine network
virsh net-undefine pfSense_network
virsh net-undefine vm_test_network
virsh net-undefine  vm_network

# Command to undefine pool
virsh pool-undefine pfSense_kvm_pool1

# Command to delete volume
virsh vol-delete --pool vm_pool1 opt/kvm/pool1/pfSense.gcow2

# Command to delete ISO file
virsh vol-delete --pool vm_pool1 /tmp/terraform-provider-libvirt-pool/vm_cloudinit.iso

rm terraform.tfstate
rm terraform.tfstate.backup

echo "Cleanup completed."


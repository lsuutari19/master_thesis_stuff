#!/bin/bash
virt-install --connect qemu:///system \
        --name="pfsense-router" \
        --cdrom pfSense-CE-2.7.2-RELEASE-amd64.iso \
        --disk path="pfSense.qcow2",size=4,bus=virtio,format=qcow2 \
        --memory=1024 \
        --graphics vnc,listen=0.0.0.0 \
        --os-variant "freebsd10.0" \
        --vcpus 2 \
        --cpu host \
        --os-type linux \
        --network network=vm_network1,model=virtio \
        --console pty,target_type=serial \
        --noautoconsole

# 08/01/2024
Started researching Terraform and learning its basics.

# 09/01/2024
General first implementatio workflow for students:

1. Student creates a VM, installs and configures it to work as a firewall
2. Student uses Terraform/alternative to create the internal network
3. Student tests different options in firewall to allow/block access to said network
4. Student uses wireshark to play around with the network

After discussing with Niklas the firewall solution should be easily deployed as well along with the internal network so students have to do as little as possible to get the platform up and running.


# 10/01/2024
Figuring out a firewall solution that can be containerized, Niklas suggested QEMU/KMV solutions, dont worry about Terraforming it yet, first work it out with simple Dockerization. Problem with pfSense that Asad suggests is that it isn't really a good solution for containerization. Tried out simple-firewall, but it is deprecated and updated 7 years ago.

Network driver seems to be connected to the solution somehow:
https://docs.docker.com/network/drivers/

Perhaps creating a container with default alpine linux and changing it's iptables configuration could be a solution, but would it be real-life scenario like? This would be handled similarly to the docker-simple-firewall solution: https://github.com/0xcaff/docker-simple-firewall/tree/master

Whalewall seems like a good solution aswell :thinking_face: but the problem with this kind of solution as well as the iptables solution above is that there is no GUI, which would be great for teaching firewall usage.

Maybe easier tasks involve using iptables to configure firewall and then the harder tasks could involve setting up pfSense in a VM to handle this.

Relevant information:
1. https://medium.com/@qwerty1q2w/docker-compose-with-public-ip-address-firewall-configuring-a0a26aa78854
2. https://blog.jarrousse.org/2023/03/18/how-to-use-ufw-firewall-with-docker-containers/
3. https://github.com/capnspacehook/whalewall
4. https://github.com/BBVA/kvm

### Meeting discussion
Teemu: every related course is built on top of:
1. how networking works
2. sysadmin skills
- do we have any courses where we can expect students to have learnt these skills
3. the sysadmin content might have to be taught first -> if these skills take up too much time we need to push someone to offer a course that teaches these skills so this course can focus on cloud security
4. Configuration exercises could be good starting exercises, looking for bad configurations and fixing them

Problems with self-created VM that will be provided to students:
- Could not start the machine pfSense because the following physical network interfaces were not found:
vboxnet0 (adapter 1), wlan0 (adapter 2),
You can either change the machine's network settings or stop the machine.
- Need to create the host only adapter yourself and use that in the network settings of the VM that contains pfSense

# 11/1/2024
Started the day by testing out Asad's pre-made VM with pfsense installed, needed to Assign Interfaces in the CLI, but afterwise the connection was smooth.
It was pretty straight forward, just create a host-only network, then create local debug.rules file in ~ , configure it to allow access from the client machine and
outward access to the virtualbox VMs IP that has the pfsense. Was feeling under the weather so did a half-day.

# 12/1 - 15/1/2024
Working on debugging why the VM doesn't have an IP / DHCP lease.

When starting the terraform apply on a new session:
    Error defining libvirt domain: virError(Code=8, Domain=10, Message='invalid argument: could not get preferred machine for /usr/bin/qemu-system-x86_64 type=kvm').

Solution: export TERRAFORM_LIBVIRT_TEST_DOMAIN_TYPE="qemu"

Network exists/Vm/pool storage exists:
________________________________________________________
virsh net-destroy vm_network1
virsh pool-destroy vm_pool1
virsh net-undefine vm_network1
virsh pool-undefine vm_pool1
virsh vol-delete --pool vm_pool1 /tmp/terraform-provider-libvirt-pool/vm-0_volume.qcow2
virsh vol-delete --pool vm_pool1 /tmp/terraform-provider-libvirt-pool/vm_cloudinit.iso

created a cleanup script from these

Error: Error: couldn't retrieve IP address of domain.Please check following:
1) is the domain running proplerly?
2) has the network interface an IP address?
3) Networking issues on your libvirt setup?
 4) is DHCP enabled on this Domain's network?
5) if you use bridge network, the domain should have the pkg qemu-agent installed
IMPORTANT: This error is not a terraform libvirt-provider error, but an error caused by your KVM/libvirt infrastructure configuration/setup
 timeout while waiting for state to become 'all-addresses-obtained' (last state: 'waiting-addresses', timeout: 5m0s)

Same configurations with Ubuntu image works, but with pfSense image the IP address cant be retrieved.



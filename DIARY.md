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
vboxnet0 (adapter 1), wlan0 (adapter 2)
You can either change the machine's network settings or stop the machine.
- Need to create a 
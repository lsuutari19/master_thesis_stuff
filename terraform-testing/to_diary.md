# VPN tasks

 Task 1 a: would be to write what they did to install and configure WireGuard on Client & pfSense.

## Installing and Configuring WireGuard for pfSense & Client conneciton

### Install WG & create keys on the Client machine
1. Install it ```apt-get install wireguard```
2. Create WG private & public keys: ```umask 077; wg genkey | tee /etc/wireguard/privatekey | wg pubkey > /etc/wireguard/publickey```

### Install & Configure WG on pfSense WebGUI
1. System->Package Manager->Available Packages->WireGuard
2. Create a WireGuard FW rule to allow all traffic
3. Create WireGuard VPN tunnel, choose IP subnet address (i.e. 172.16.16.0)
4. Create a Firewall UDP protocol rule for port chosen before to WAN address (default port 51820)
5. Optional FW NAT Outbound -> Hybrid, create a new WAN IPv4 mapping to the previous IP (i.e. 172.16.16.0) & choose Hybdrid Outbound, this enables network to be outbound through NAT for a full-tunnel connection
6. Create a VPN WireGuard peer to the created tunnel with a defined subnet address (i.e. 172.16.16.2)
7. Enable tunneling from Interaces -> Assignments -> Add

### Configure WG on the Client machine
1. Create pfvpn.conf to /etc/wireguard/
2. Contents of the file should be following: 
```
    [Interface]
    PrivateKey = <private key we created before>
    Address = <the VPN wireguard peer IP i.e. 172.16.16.2/24>

    [Peer]
    PublicKey = <the WG tunnel public key from WebGUI>
    Endpoint = <pfSense WAN>:<WG Port default 51820>
    AllowedIPs = <Internal Network Addresses>
```
3. Start the VPN connection and access take screenshots of the pfSense webGUI WireGuard Status section & of the successful ping to internal network.

Task 1 b: Explain the differences between split tunneling and full tunneling in regards to VPN tunneling 

## Blocking the Client from accessing some resource
Task 1 c: write up of what they did to block the Client VPN machine from being able to access DMZ or Kali machine.

To-Do: Write example answer instructions

## Some other ideas:
1. Misconfigured VPN firewall settings
2. S2S, protocols, differences between tunneling options

____________________________________________________________


# IN OPENVPN
## OpenVPN Server Settings
1. VPN -> OpenVPN -> Wizard (follow installation wizard)
2. In Tunnel Settings IPv4 Tunnel Network: 192.168.200.0/24
3. IPv4 Local Network 10.0.0.0/24 (pfSense LAN)
4. Check Firewall Rule [] & OpenVPN rule []

## OpenVPN Client Settings
1. Download openvpn-client-export from pfSense package manager
2. Create user profile System->Users
3. Create User cert during process


rLSx80DXq+45qthYHZyQiVCD/PNqP0e5hNfNxeDvnn8=

# Netboot from a Docker Container
This Docker container lets you PXE boot a whole bunch of installers and
utilities on your local network, without much mucking about configuring
DHCP and TFTP servers, using the excellent [netboot.xyz](https://netboot.xyz/)
project.

It provides a ProxyDHCP service, so for most clients your network's existing
DHCP server (e.g. your home router) continues to hand out IP addresses as
normal. However when a PXE client makes a DHCP request, this container also
responds to announce itself as a TFTP network boot target. It does this using
[dnsmasq](https://en.wikipedia.org/wiki/Dnsmasq) to run a very minimal DHCP
server, on top of the [linuxserver/docker-netboot.xyz](https://github.com/linuxserver/docker-netbootxyz)
container.

## Why would I want this?!
I created this because I can never find a serviceable USB stick that's not in
use when I want to run a Linux installer/memtest/Clonezilla etc, but I don't
need to permanently run a DHCP and TFTP server - most of the time my router is
just fine.

## How do I run it on Linux?
On Linux you can run something like:
```bash
docker run --net=host --cap-add=NET_ADMIN -e DHCP_RANGE_START=192.168.0.1 samdbmg/dhcp-netboot.xyz
```
Make sure you adjust the IP address in `DHCP_RANGE_START` to the first address
on your network. dnsmasq will automatically figure out the right subnet mask to
use based on your local network setup.

Then boot another device on the same network and ask it to boot from "LAN" or
"PXE" or whatever your device happens to call it. You should be presented with
a nice menu of live disks, installers and utilities to run, which will be
downloaded from the Internet as needed.

### Why do I need `--net=host`?
To play DHCP server, the container needs to have an interface on the target
network, rather than the Docker internal bridge.

## What about Mac/Windows?
On Mac and Windows Docker is usually a VM running in the background, and the
client is set up to (mostly) transparently pass commands through to that VM and
deal with forwarded ports and the like.

Unfortunately that doesn't work here, because then your Docker host doesn't have
an address on the network it is acting as DHCP server for. However all is not
lost, because a Vagrantfile is provided here to let you run the container in a
Virtualbox VM. By default a simple `vagrant up` will only start the demo (see
[below](##Demo)), but you can specify the machine to start instead:
```
DHCP_RANGE_START=192.168.0.1 vagrant up netboot
vagrant ssh netboot -c 'docker logs -f samdbmg-dhcp-netboot.xyz'
```
**Note:** You might be prompted to select which network the VM should connect to, choose
the one matching the IP address you gave.

It will boot an Ubuntu VM, install Docker on it and then fetch and start the
container. The second command will SSH you into the VM and start tailing the
netboot containers logs.

For this to work on Windows using Hyper-V as a backend, you'll need to use an
Administrator command prompt.

## Firewall
Don't forget, if you've got a firewall running on your system you'll need to
allow UDP traffic to ports 67 (DHCP), 69 (TFTP) and 4011 (PXE), along with
TCP port 80 (HTTP) for the built in webserver. For `ufw`, try:
```bash
sudo ufw allow proto udp from any to any port 67
sudo ufw allow proto udp from any to any port 69
sudo ufw allow proto udp from any to any port 4011
sudo ufw allow proto tcp from any to any port 80
```
Don't forget to remove the rules when you're done!

## Demo
There's a [Vagrantfile](Vagrantfile) in this directory that demonstrates starting
up a Virtualbox VM managed by Vagrant, bridged onto your host network and configured
to PXE boot. To try it, run `./run-demo.sh 192.168.0.1` which will launch the Docker
container and bring up a Vagrant box.

**Note:** You might be prompted to select which network the VM should connect to, choose
the one matching the IP address you gave.

You should see something like (also at slightly better quality
[on YouTube](https://www.youtube.com/watch?v=P-uuXoFdF54)):
![Screen recrding of running demo](docs/screencast.gif)

*Note that the Virtualbox Extension Pack might be needed for PXE boot to work,
and it's configured with 3GB RAM so that live disks ISOs can be downloaded.*

### Running the demo on Mac/Windows with Virtualbox
Run `DHCP_RANGE_START=192.168.0.1 vagrant up netboot demo`.

You'll probably be prompted twice for the network to attach to.

### Running the demo on Windows with Virtualbox
Unfortunately the PXE boot box used for the demo is only built for Virtualbox,
if you're using Hyper-V you'll have to create yourself a VM and configure it
to boot from the network (disable Secure Boot too, probably).

## Building Locally
Should be as simple as `docker build .`

## Why doesn't it work on $SCHOOL or $COMPANY network
Enterprise-grade networking gear usually has some protections to prevent just
anyone running a DHCP server, which might mean this doesn't work across a
corporate/school network. Sorry.

## Contributing
**I've found a problem**
Open an Issue on the repo, I'll try and get back to you.

**I've fixed a problem**
Yay! Open a PR!

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

## How do I run it?
Run something like:
```bash
docker run --net=host -e DHCP_RANGE_START=192.168.0.1 samdbmg/dhcp-netboot.xyz
```
Make sure you adjust the IP address in `DHCP_RANGE_START` to the first address
on your network. dnsmasq will automatically figure out the right subnet mask to
use based on your local network setup.

Then boot another device on the same network and ask it to boot from "LAN" or
"PXE" or whatever your device happens to call it. You should be presented with
a nice menu of live disks, installers and utilities to run, which will be
downloaded from the Internet as needed.

### Why do I need `--net=host`?
To play DHCP server, the container needs listen to broadcasts on the target
network, which doesn't seem to work with port forwarding.

### Firewall
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
The [vagrant-demo/](vagrant-demo/) directory contains a demo of this container
using a Virtualbox VM managed by Vagrant, bridged onto your host network. To
run it:
```bash
cd vagrant-demo
./run-demo.sh 192.168.0.1
```
You might be prompted to select which network the VM should connect to, choose
the one matching the IP address you gave.

You should see something like:
TODO: Screencast

*Note that the Virtualbox Extension Pack might be needed for PXE boot to work,
and it's configured with 3GB RAM so that live disks ISOs can be downloaded.*

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

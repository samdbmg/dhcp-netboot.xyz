FROM linuxserver/netbootxyz:latest

# Install dnsmasq to play DHCP server
RUN apk add --update dnsmasq

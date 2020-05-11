FROM linuxserver/netbootxyz:latest

# Install dnsmasq to play DHCP server
RUN apk add --update dnsmasq

# Copy config files for dnsmasq, and running as a service
COPY etc /etc/

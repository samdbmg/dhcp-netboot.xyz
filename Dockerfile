FROM linuxserver/netbootxyz:latest

# Install dnsmasq to play DHCP server
RUN apk add --update dnsmasq

# Copy config files for dnsmasq, and running as a service
COPY etc /etc/

# Set the start of the IP range to reply to PXE DHCP requests on
ENV DHCP_RANGE_START=192.168.0.1

# dnsmasq will be started as a system service by the s6 supervisor

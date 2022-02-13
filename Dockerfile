FROM linuxserver/netbootxyz:latest

# Install dnsmasq to play DHCP server
RUN apk add --update dnsmasq

# Delete the TFTP config from the underlying image: dnsmasq does that here
RUN rm -rf /etc/services.d/tftp

# Copy config files for dnsmasq, and running as a service
COPY etc /etc/

# Set the start of the IP range to reply to PXE DHCP requests on
ENV DHCP_RANGE_START=192.168.0.1

# dnsmasq will be started as a system service by the s6 supervisor

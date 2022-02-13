# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Define a Vagrant machine which should PXE boot off the docker cotnainer
  config.vm.define :demo, primary: true do |demo|
    demo.vm.box = "bento/ubuntu-20.04"

    # Bridge the VM onto your host's network
    demo.vm.network "public_network"

    # Don't wait for VM to boot - it won't finish anyway
    demo.vm.boot_timeout = 5

    demo.vm.provider "virtualbox" do |vb|
        # Display the GUI so we can see what it does
        vb.gui = true

        # Add enough RAM to download Ubuntu live
        vb.memory = 5120

        # Enable PXE boot as the only option
        vb.customize ["modifyvm", :id, "--boot1", "net"]

        # Disconnect the default NIC
        vb.customize ["modifyvm", :id, "--nic1", "none"]
    end
  end

  # For platforms where the Docker container won't work, this boots a VM that
  # runs the container instead
  config.vm.define :netboot, autostart: false do |netboot|
    netboot.vm.box = "bento/ubuntu-20.04"

    # Bridge the VM onto your host's network
    netboot.vm.network "public_network"

    # Read a DHCP range from the environment, if one was set
    dhcp_range_start = ENV.has_key?("DHCP_RANGE_START") ? ENV["DHCP_RANGE_START"] : "192.168.0.1"

    # Bring up a Docker container running the netboot server
    netboot.vm.provision "docker" do |d|
      d.run "samdbmg/dhcp-netboot.xyz",
        args: "--net=host --cap-add=NET_ADMIN -e DHCP_RANGE_START=" + dhcp_range_start
    end
  end

  # If the host system uses proxies, set proxies
  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = ENV["http_proxy"]
    config.proxy.https    = ENV["https_proxy"]
    config.proxy.no_proxy = ENV["no_proxy"]
  end

  # Turn off shared folders, we don't need them!
  # config.vm.synced_folder '.', '/vagrant', disabled: true
end

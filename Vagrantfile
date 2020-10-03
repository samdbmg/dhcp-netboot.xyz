# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "clink15/pxe"

  # Bridge the VM onto your host's network
  config.vm.network "public_network"

  # Don't wait for VM to boot - it won't finish anyway
  config.vm.boot_timeout = 5

  config.vm.provider "virtualbox" do |vb|
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

# wiki.nixos.org/wiki/VirtualBox
{ ... }: {
  # Use the VirtualBox video driver for display acceleration.
  services.xserver.videoDrivers = [ "virtualbox" "modesetting" ];
  boot.initrd.kernelModules = [ "vboxvideo" ];

  virtualisation.virtualbox.guest = {
    enable = true;
    dragAndDrop = true;
  };

  services.virtualboxGuest.enable = true;
}

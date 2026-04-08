# Nouveau - open source NVIDIA drivers.
{ config, ... }: {
  services.xserver.videoDrivers = [ "nouveau" ];
}
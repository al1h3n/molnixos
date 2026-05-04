# Nouveau - open source NVIDIA drivers.
{ ... }: {
  services.xserver.videoDrivers = [ "nouveau" ];
}
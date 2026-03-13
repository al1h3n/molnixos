# nixos.wiki/wiki/AMD_GPU

{ config, pkgs, ... }: {
  {
  services.xserver.videoDrivers = [ "amdgpu-pro" ];
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Required for OpenGL and OpenCL (Pro version)
  hardware.opengl.extraPackages = with pkgs; [
    amdgpu-pro-all
  ];
  }
}
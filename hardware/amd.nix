# nixos.wiki/wiki/AMD_GPU
{ pkgs, ... }: {
  services.xserver.videoDrivers = [ "amdgpu-pro" ];
  boot.initrd.kernelModules = [ "amdgpu" ];

  environment.systemPackages = [ pkgs.nvtopPackages.amd ];

  # Required for OpenGL and OpenCL (Pro version)
  hardware.opengl.extraPackages = [ pkgs.amdgpu-pro-all ];

  # Tuning your GPU (AMD exclusive).
  programs.corectrl = {
    enable = true;
    gpuOverclock.enable = true;
  };
}
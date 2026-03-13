# AMD iGPU

{ config, pkgs, ... }: {
  boot.initrd.kernelModules = [ "amdgpu" ];
}
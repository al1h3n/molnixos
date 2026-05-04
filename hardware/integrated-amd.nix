# AMD iGPU
{ ... }: {
  boot.initrd.kernelModules = [ "amdgpu" ];
}
# Example of combining INTEL iGPU and NVIDIA GPU
{ ... }: {
  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0"; # Run `lspci | grep VGA` to confirm
    nvidiaBusId = "PCI:1:0:0";
    offload.enable = true;
    offload.auto = true; # Automatically offload supported applications
  };
}
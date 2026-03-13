{ pkgs, ... }: {
  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-media-driver  # For modern Intel GPUs
      vpl-gpu-rt          # For OneVPL and better compatibility
      intel-compute-runtime # For OpenCL/Level Zero
    ];
  };

  # Optional: For older Arc cards or early firmware, you may need to force probe
  # boot.kernelParams = [ "i915.force_probe=<your-gpu-id>" ];
}
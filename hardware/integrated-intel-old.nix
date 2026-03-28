# For ones older than Broadwell (2015). For newer use arc.nix (even if you have integrated Intel GPU)
{ pkgs, ... }: {
  # Enable OpenGL/Graphics
  hardware.graphics = {
    enable = true;
    
    # Required for older Intel GPUs (Pre-Broadwell)
    extraPackages = with pkgs; [
      intel-vaapi-driver # Formerly vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Set environment variable for VA-API
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "i965"; };
}

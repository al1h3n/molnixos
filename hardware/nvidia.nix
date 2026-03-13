# wiki.nixos.org/wiki/NVIDIA
{ config, ... }: {
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Keep this false unless you have graphical corruption after waking up from sleep.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the proprietary closed-source driver.
    # (Set to true ONLY if you have an RTX 2000 series or newer AND want the open-source kernel modules).
    open = false;

    # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # If you have an older GPU (e.g., GTX 900 series or older), you might need a legacy driver:
    # package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  };
}
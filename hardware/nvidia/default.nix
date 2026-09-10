{ pkgs, ... }: {
  imports = [
    ./propietary.nix
    # ./nouveau.nix
  ];
  environment = {
    systemPackages = with pkgs; [ nvidia-vaapi-driver nvtopPackages.nvidia ];
    variables = { __GLX_VENDOR_LIBRARY_NAME = "nvidia"; };
  };
  systemd.services.libvirtd.environment = {
    __EGL_VENDOR_LIBRARY_DIRS = "/run/opengl-driver/share/glvnd/egl_vendor.d";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # GBM_BACKEND = "nvidia-drm";
    EGL_PLATFORM = "device";
    LIBGL_ALWAYS_SOFTWARE = "0";
  };

  # Fix for systemctl sleep-ish functions.
  # mem_sleep_default=s2idle kept deliberately: this box has no working S3 with
  # the NVIDIA driver. Drop it if `cat /sys/power/mem_sleep` shows [deep] works,
  # since s2idle draws noticeably more power.
  boot.kernelParams = [ "mem_sleep_default=s2idle" ];
  boot.extraModprobeConfig = ''
    options nvidia NVreg_TemporaryFilePath=/var/tmp
  '';
}
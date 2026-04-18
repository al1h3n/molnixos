{ pkgs, ... }: {
  imports = [
    ./propietary.nix
    # ./nouveau.nix
  ];
  extraPackages = with pkgs; [
    nvidia-vaapi-driver  # bridges NVDEC → VAAPI
  ];
  environment.variables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
  systemd.services.libvirtd.environment = {
    __EGL_VENDOR_LIBRARY_DIRS = "/run/opengl-driver/share/glvnd/egl_vendor.d";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # GBM_BACKEND = "nvidia-drm";
    EGL_PLATFORM = "device";
    LIBGL_ALWAYS_SOFTWARE = "0";
  };
}
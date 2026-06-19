{ pkgs, ... }: {
  services.xserver.desktopManager.xfce = {
    enable = true;
    enableScreensaver = false;
    # noDesktop = true;
  };
}

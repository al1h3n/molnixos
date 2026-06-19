{ pkgs, ... }: {
  services.xserver.desktopManager.xfce = {
    enable = true;
    enableScreensaver = false;
    # noDesktop = true;
  };
  environment.xfce.excludePackages = with pkgs.xfce; [
    xfce4-taskmanager
    xfce4-terminal
    parole
  ];
}

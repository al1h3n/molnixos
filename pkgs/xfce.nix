{ pkgs, ... }: {
  services.xserver.desktopManager.xfce = {
    enable = true;
    enableScreensaver = false;
    # noDesktop = true;
  };
  environment = {
    xfce.excludePackages = with pkgs.xfce; [
      xfce4-taskmanager
      xfce4-terminal
      parole
      tango-icon-theme
      rodent-icon-theme
    ];
    systemPackages = with pkgs; [
      xfce4-whiskermenu-plugin
    ];
  };
}

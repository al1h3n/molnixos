{ pkgs, ... }: {
  services.xserver.desktopManager.xfce = {
    enable = true;
    enableScreensaver = false;
    # noDesktop = true;
  };
  environment = {
    xfce.excludePackages =
    (with pkgs; [
      parole
      tango-icon-theme
      xfce4-taskmanager
      xfce4-terminal
    ]);
    systemPackages = with pkgs; [
      xfce4-whiskermenu-plugin
    ];
  };
}

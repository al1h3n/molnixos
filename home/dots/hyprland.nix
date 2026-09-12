# User-wide hyprland module.
{ pkgs, config, variables, inputs, ... }: {
  # Enabling Hyprland.
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # Might break hyprland autolaunch.
    xwayland.enable = true;
  };

  # Packages.
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  home.packages = with pkgs; [
    hyprmod
    hyprmoncfg
    hyprglass
  ];

  # Files.
  xdg.configFile = {
    "hypr/hyprland.lua" = {
      source = config.lib.file.mkOutOfStoreSymlink variables.hyprland;
      force = true;
    };
  };
}

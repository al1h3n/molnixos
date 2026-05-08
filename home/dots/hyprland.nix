# User-wide hyprland module.
{ pkgs, config, variables, ... }: {
  # Enabling Hyprland.
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # Might break hyprland autolaunch.
    xwayland.enable = true;
  };

  # Add hyprmod (settings app, aur.archlinux.org/packages/hyprmod-git) when released in nixOS packages.
  # home.packages = with pkgs; [
  #   hyprmod
  # ];

  xdg.configFile = {
    "hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink variables.hyprland;
    # "hypr/custom".source = config.lib.file.mkOutOfStoreSymlink "${toString variables.shared}/custom";
  };

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
}

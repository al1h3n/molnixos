{ config, variables, ... }: {
  # Enabling Hyprland.
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = false; # Might break hyprland autolaunch.
  };

  xdg.configFile."hypr/hyprland.conf".source =
    config.lib.file.mkOutOfStoreSymlink variables.hyprland;
  xdg.configFile."hypr/custom".source =
    config.lib.file.mkOutOfStoreSymlink "${toString variables.shared}/custom";
}
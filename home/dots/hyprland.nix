{ pkgs, variables, config, ... }: {
  home.packages = with pkgs;[
      hyprlock hyprshell
      brightnessctl
      blueman
      wtype
      
      (rofi.override {
      plugins = [ rofi-emoji rofi-calc ];})
      
      swww 
      waypaper mpvpaper
      wl-clip-persist
      grim
      cliphist
      
      waybar # quickshell
      swaynotificationcenter
  ];

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
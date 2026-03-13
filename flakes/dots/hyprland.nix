{ pkgs, variables, ... }: {
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
      hyprpolkitagent
      
      waybar # quickshell
      swaynotificationcenter
  ];

  # Enabling Hyprland.
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = false; # Might break hyprland autolaunch.
  };

  # Works by applying files to ~/.config/"string" directory.
  xdg.configFile."hypr/hyprland.conf".source = variables.hyprland;
  xdg.configFile."hypr/custom".source = "${variables.shared}/custom";
}
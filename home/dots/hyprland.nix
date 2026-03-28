{ pkgs, variables, config, ... }: {
  home.packages = with pkgs;[
      hyprlock hyprshell
      brightnessctl
      blueman
      wtype
      
      (rofi.override {
      plugins = [ rofi-emoji rofi-calc ];})
      
      (tesseract5.override { enableLanguages = [ "eng" "rus" "chi_sim" ]; })
      swww 
      waypaper mpvpaper
      wl-clip-persist
      grim slurp xdg-user-dirs wl-clipboard
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
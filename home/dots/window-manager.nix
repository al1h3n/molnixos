{ pkgs, ... }: {
  home.packages = with pkgs;[
      hyprlock hyprshell
      brightnessctl
      blueman
      wtype
      
      (rofi.override {
      plugins = [ rofi-emoji rofi-calc ];})
      
      (tesseract5.override { enableLanguages = [ "eng" "rus" "chi_sim" ]; })
      awww 
      waypaper mpvpaper
      wl-clip-persist
      grim slurp xdg-user-dirs wl-clipboard playerctl
      cliphist
      
      yad # Create windows.

      jq waybar # quickshell
      swaynotificationcenter
  ];
}
{ pkgs, ... }: {
  home.packages = with pkgs;[
      hyprlock hyprshell
      brightnessctl
      blueman
      wtype
      
      (rofi.override {
      plugins = [ rofi-emoji rofi-calc ];})
      yad # Create windows.

      (tesseract5.override { enableLanguages = [ "eng" "rus" "chi_sim" ]; })
      awww mpvpaper waypaper
      wl-clipboard wl-clip-persist cliphist
      grim slurp wf-recorder
      xdg-user-dirs playerctl

      jq waybar # quickshell
      swaynotificationcenter
  ];
}
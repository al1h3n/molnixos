{ inputs, pkgs, ... }: {
  home.packages = with pkgs;[
      hyprlock hyprshell
      brightnessctl
      blueman
      wtype
      wlogout
      
      (rofi.override {
      plugins = [ rofi-emoji rofi-calc ];})
      yad # Create windows.

      (tesseract5.override { enableLanguages = [ "eng" "rus" "chi_sim" ]; })
      awww mpvpaper waypaper
      wl-clipboard wl-clip-persist cliphist
      grim slurp wf-recorder satty hyprshot
      xdg-user-dirs playerctl

      jq waybar # quickshell
      swaynotificationcenter

      inputs.ie-r.packages.${pkgs.system}.default # Eyedropper.
  ];
}
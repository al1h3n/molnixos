{ inputs, pkgs, ... }: {
  home.packages = with pkgs;[
      # Hyprland ecosystem.
      hyprlock

      # Hardware.
      brightnessctl blueman

      # Backend.
      xdg-user-dirs playerctl

      # Wayland backend.
      wtype wlogout

      # UI.
      yad
      (rofi.override {
      plugins = [ rofi-emoji rofi-calc ];})

      # OCR.
      (tesseract5.override { enableLanguages = [ "eng" "rus" "chi_sim" ]; })

      # Wallpapers.
      awww mpvpaper waypaper pywal16 wallust matugen
      # Screenshots and recorders.
      grim slurp wf-recorder satty hyprshot

      # Clipboards.
      wl-clipboard wl-clip-persist cliphist

      # Bar, action managers and notifications.
      # waybar # wayle
      # quickshell
      swaynotificationcenter
      inputs.ie-r.packages.${pkgs.stdenv.hostPlatform.system}.default # Eyedropper.
  ];
}
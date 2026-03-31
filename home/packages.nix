# Packages for home-manager.

{ pkgs, variables, inputs, ... }: {
  home = {
    username = variables.username;
    homeDirectory = "/home/${variables.username}";
    packages = with pkgs; [

      # Multimedia
      songrec obs-studio
      ffmpeg-headless imagemagick_light
      yt-dlp
      inputs.yt-x.packages.${pkgs.stdenv.hostPlatform.system}.default

      # Utilities
      cpu-x cava tealdeer zenity pay-respects piper openrgb-with-all-plugins

      # Studying.
      (anki.withAddons (with ankiAddons; [
        passfail2
        anki-connect
        review-heatmap
        # more-overview-stats not exist on nixOS
      ]))

      # Music
      spotify

      # Coding
      vscodium
      # zed-editor
      
      # Gaming
      gamemode wine winetricks protontricks
      prismlauncher steam

      # Art
      # krita blender

      # Social
      vesktop telegram-desktop # _64gram

      # Notes
      obsidian appflowy # notion-app only on macOS, enhanced one is write screen.
      
      # Shell
      kitty

      # Office
      # freeoffice
    ];
  };
}
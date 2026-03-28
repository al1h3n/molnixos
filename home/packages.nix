# Packages for home-manager.

{ pkgs, variables, inputs, ... }: {
  home = {
    username = variables.username;
    homeDirectory = "/home/${variables.username}";
    packages = with pkgs; [

      # Multimedia
      mpv songrec obs-studio
      ffmpeg-headless imagemagick_light
      yt-dlp
      inputs.yt-x.packages.${pkgs.stdenv.hostPlatform.system}.default

      # Utilities
      cpu-x cava tealdeer zenity bat pay-respects file
      # virt-manager
      openrgb piper

      # Studying.
      (anki.withAddons [
        ankiAddons.passfail2
        ankiAddons.anki-connect
      ])

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
      notion-app-electron

      # Shell
      kitty eza yazi fzf

      # Office
      # freeoffice
    ];
  };
}
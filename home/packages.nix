# Packages for home-manager.

{ pkgs, variables, ... }: {
  home = {
    username = variables.username;
    homeDirectory = "/home/${variables.username}";
    packages = with pkgs; [

      # Multimedia
      mpv songrec obs-studio
      ffmpeg-headless imagemagick_light

      # Utilities
      cpu-x cava
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
      vesktop # _64gram

      # Notes
      obsidian appflowy # notion-app only on macOS, enhanced one is write screen.

      # Shell
      kitty eza yazi fzf

      # Office
      # freeoffice
    ];
  };
}
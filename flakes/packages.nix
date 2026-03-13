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
      cpu-x
      kdePackages.qt6ct
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
      gamemode
      wine winetricks protontricks
      prismlauncher

      # Social
      vesktop # _64gram

      # Notes
      obsidian notion-app-enhanced # notion-app only on macOS

      # Shell
      kitty eza yazi fzf
    ];
  };
}
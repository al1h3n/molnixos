# Packages for home-manager.

{ pkgs, variables, inputs, ... }: {
  home = {
    username = variables.username;
    homeDirectory = "/home/${variables.username}";
    packages = with pkgs; [

      # Multimedia
      songrec obs-studio
      ffmpeg-full imagemagickBig
      yt-dlp
      inputs.yt-x.packages.${pkgs.stdenv.hostPlatform.system}.default

      # Utilities
      cpu-x cava tealdeer zenity pay-respects piper openrgb-with-all-plugins

      # Cool utilities for no reason.
      cool-retro-term # RMB to change profile
      genact # Random logs.
      hollywood # Crazy ass random hacker stuff
      cbonsai
      lavat # Lava lamp.
      pipes-rs # Infinite pipes
      cmatrix unimatrix
      # rusty-rain # Better cmatrix, no in nixOS packages now.
      mapscii # Map
      toilet # Rich print
      tty-clock termdown
      globe-cli

      # Studying.
      (anki.withAddons (with ankiAddons; [
        passfail2
        anki-connect
        review-heatmap
        # more-overview-stats not exist on nixOS
      ]))
      dialect # Translator

      # Coding
      vscodium
      # zed-editor
      
      # Music.
      lazyspotify

      # Gaming
      gamemode wine winetricks protontricks
      prismlauncher steam

      # Art
      krita # blender
      losslesscut-bin # To remove part of videos without losing quality.

      # AI, upscaling
      upscayl

      # Social
      vesktop telegram-desktop # _64gram

      # Notes
      obsidian appflowy # notion-app only on macOS, enhanced one is write screen.
      
      # Shell
      kitty

      # Sharing files
      localsend

      # Office
      # freeoffice
    ];
  };
}
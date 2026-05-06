# Packages for home-manager.

{ pkgs, variables, inputs, ... }: {
  home = {
    username = variables.username;
    homeDirectory = "/home/${variables.username}";
    packages = with pkgs; [

      # Multimedia.
      songrec obs-studio
      ffmpeg-full imagemagickBig
      gthumb
      yt-dlp
      inputs.yt-x.packages.${pkgs.stdenv.hostPlatform.system}.default

      # Utilities.
      cpu-x cava tealdeer zenity pay-respects piper openrgb-with-all-plugins
      
      # Anifetch doesn't have some dependencies.
      (inputs.anifetch.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
        propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ (with pkgs.python3Packages; [
          wcwidth
          rich
          pynput
        ]);
      }))

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
      noteshrink # Convert photos of copybook to better and compressed ones.
      speedread # Read files fast from plain text.

      # Coding.
      vscodium
      
      # Music.
      # lazyspotify # Only with Premium subscription.

      # Gaming.
      gamemode wine winetricks protontricks
      prismlauncher steam
      inputs.setrixtui.packages.${pkgs.stdenv.hostPlatform.system}.default

      # Art.
      krita # blender
      losslesscut-bin # To remove part of videos without losing quality.

      # AI, upscaling.
      upscayl

      # Social.
      telegram-desktop # _64gram
      vesktop # equicord # Can't see the package in app list or commands.

      # Notes.
      obsidian # appflowy # notion-app only on macOS, enhanced one is write screen.
      
      # Shell.
      kitty

      # Sharing files.
      localsend

      # Office
      # freeoffice

      # Hacking.
      johnny john # GUI and CLI.

      # Managing disks.
      gparted

      # Test internet speed.
      speedtest-cli

      # Dual monitors with different devices.
      # deskreen

      # Wallpapers.
      gowall # Doesn't fit well with waypaper.
    ];
  };
  services = {
    activitywatch.enable = true;
  };
}
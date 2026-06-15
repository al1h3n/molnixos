# Packages for home-manager.

{ pkgs, variables, inputs, ... }: {
  home = {
    username = variables.username;
    homeDirectory = "/home/${variables.username}";
    packages = with pkgs; [

      # Multimedia.
      songrec obs-studio
      imagemagickBig
      nsxiv geeqie # gthumb uses pixbuf, not imagemagickBig
      yt-dlp
      inputs.yt-x.packages.${pkgs.stdenv.hostPlatform.system}.default

      # Backend.
      jq

      # Utilities.
      cpu-x cava tealdeer zenity pay-respects piper openrgb-with-all-plugins
      dupeguru # To remove duplicated files. Add game directories to exceptions.
      bitwarden-desktop # Password manager.

      # Anifetch doesn't have some dependencies.
      (inputs.anifetch.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.pythonRelaxDepsHook ];
        pythonRelaxDeps = [ "wcwidth" "rich" "pynput" ];
      }))

      # Cool utilities for no reason.
      pokemon-colorscripts # Pokemons.
      cool-retro-term # RMB to change profile.
      genact # Random logs.
      hollywood # Crazy ass random hacker stuff.
      cbonsai
      lavat # Lava lamp.
      pipes-rs # Infinite pipes.
      cmatrix unimatrix
      # rusty-rain # Better cmatrix, no in nixOS packages now.
      mapscii # Map.
      toilet tuilet # Rich print.
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
      zathura # PDF viewer.
      masterpdfeditor # PDF editor.

      # Coding.
      vscodium

      # Music.
      # lazyspotify # Only with Premium subscription.

      # Gaming.
      protontricks # Fix tool if game not working.
      # protontricks - better winetricks, steam uses own Proton.
      mangohud # FPS counter, enable manually.
      protonplus # Better protonup-qt. Manage proton versions. Add portprotonqt when released.
      heroic # Game launcher, lutris has bugs.
      prismlauncher
      inputs.setrixtui.packages.${pkgs.stdenv.hostPlatform.system}.default

      # Art.
      krita gimp # blender
      losslesscut-bin # To remove part of videos without losing quality.

      # AI, upscaling.
      # upscayl # Run "nix run github:mayjs/upscayl_nixos" if doesn't work.

      # Social.
      _64gram # telegram-desktop
      goofcord # Supports Vencord, Equicord and others. Optimized as well.

      # Notes.
      obsidian # appflowy # notion-app only on macOS, enhanced one is write screen.

      # Shell.
      kitty wezterm zellij

      # Sharing files.
      localsend
      warp # Online file transfer.

      # Office
      # freeoffice

      # Hacking.
      johnny john # GUI and CLI. (has some error in nixpkgs)

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
}
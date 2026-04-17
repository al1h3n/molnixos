# Spicetify manages Spotify automatically.
{ inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  liquify = pkgs.fetchFromGitHub {
    owner = "NMWplays";
    repo = "Liquify";
    rev = "main";
  };
in {
  # packages = with pkgs; [ spotify ];
  programs.spicetify = {
    enable = true;

    # Marketplace.
    enabledCustomApps = with spicePkgs.apps; [ marketplace ];

    # Theme.
    # theme = spicePkgs.themes.defaultDynamic;
    # Or something like spicePkgs.themes.catppuccin

    theme = liquify;
    colorScheme = "Base";

    # Optional: add extensions
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      shuffle # Proper shuffle with zero bias.
      autoSkipVideo
      hidePodcasts
      keyboardShortcut
      volumePercentage
      trashbin # Remove artists from playing.
      betterGenres # Song genre.

      aiBandBlocker # Skip AI slop.
      powerBar # macOS bar for search
      copyToClipboard # Copy song name.
      spicyLyrics # Better lyrics.
      copyLyrics
      history # History of playing.
      sessionStats
      # focusMode
    ];

    enabledSnippets = with spicePkgs.snippets; [
      hideLyricsButton
    ];
  };
}
# Spicetify manages Spotify automatically.
{ inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  # packages = with pkgs; [ spotify ];
  programs.spicetify = {
    enable = true;

    # Marketplace.
    enabledCustomApps = with spicePkgs.apps; [ marketplace ];

    # Theme.
    theme =
    # Or something like spicePkgs.themes.catppuccin
    colorScheme = "mocha";

    # Optional: add extensions
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      shuffle # Proper shuffle with zero bias.
      autoSkipVideo
      hidePodcasts
      keyboardShortcut
      volumePercentage
      loopyLoop # Select a part to loop.
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
  };
}
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

    # Theme - nix eval --impure --json --expr 'builtins.attrNames ((builtins.getFlake "github:Gerg-L/spicetify-nix").legacyPackages.x86_64-linux.themes)'
    theme = spicePkgs.themes.text;

    # Optional: add extensions
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      shuffle # Proper shuffle with zero bias.
      autoSkipVideo
      hidePodcasts


      
      volumePercentage
      betterGenres # Song genre.

      aiBandBlocker # Skip AI slop.
      powerBar # macOS bar for search
      copyToClipboard # Copy song name.
      copyLyrics
      history # History of playing.
      

      # Irritating but useful.
      # spicyLyrics # Better lyrics.
      # sessionStats # On right side, pretty big.
      # trashbin # Remove artists from playing, weird .JPG icon.
    ];

    # Snippets - nix eval --impure --json --expr 'builtins.attrNames ((builtins.getFlake "github:Gerg-L/spicetify-nix").legacyPackages.x86_64-linux.snippets)'
    enabledSnippets = with spicePkgs.snippets; [
      hideLyricsButton
      sonicDancing
    ];
  };
}
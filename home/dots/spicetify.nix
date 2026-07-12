# Spicetify manages Spotify automatically - gerg-l.github.io/spicetify-nix
{ inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [
    # ./spicetify-themes/tui.nix
    ./spicetify-themes/gui.nix
  ];

  # Spotify shouldn't be installed with spicetify.
  # packages = with pkgs; [ spotify ];

  programs.spicetify = {
    enable = true;

    # Marketplace.
    enabledCustomApps = with spicePkgs.apps; [ marketplace ];

    # Theme - nix eval --impure --json --expr 'builtins.attrNames ((builtins.getFlake "github:Gerg-L/spicetify-nix").legacyPackages.x86_64-linux.themes)'
    # theme = spicePkgs.themes.text;

    # Extensions - nix eval --impure --json --expr 'builtins.attrNames ((builtins.getFlake "github:Gerg-L/spicetify-nix").legacyPackages.x86_64-linux.extensions)'
    enabledExtensions = with spicePkgs.extensions; [
      # Main extensions.
      adblock
      shuffle # Proper shuffle with zero bias.
      autoSkipVideo
      hidePodcasts
      volumePercentage
      betterGenres # Song genre.
      aiBandBlocker # Skip AI slop.
      copyToClipboard # Copy song name.
      copyLyrics
      history # History of playing.

      # Irritating but useful.
      # spicyLyrics # Better lyrics.
      # sessionStats # On right side, pretty big.
      # trashbin # Remove artists from playing, weird .JPG icon.
    ];

    # Snippets - nix eval --impure --json --expr 'builtins.attrNames ((builtins.getFlake "github:Gerg-L/spicetify-nix").legacyPackages.x86_64-linux.snippets)'
    # enabledSnippets = with spicePkgs.snippets; [];
  };
}
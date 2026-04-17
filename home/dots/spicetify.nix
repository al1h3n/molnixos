# Spicetify manages Spotify automatically.
{ inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  # packages = with pkgs; [ spotify ];
  programs.spicetify = {
    enable = true;

    # Optional: pick a theme
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";

    # Optional: add extensions
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      shuffle
    ];
  };
}
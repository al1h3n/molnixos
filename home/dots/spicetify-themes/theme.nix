# Terminal UI theme for Spicetify.
{ inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  programs.spicetify = {
    theme = spicePkgs.themes.retroBlur;
    # onepunch - gruvbox, starryNight, text - spotify-tui, defaultDynamic, retroBlur, hazy
  };
}
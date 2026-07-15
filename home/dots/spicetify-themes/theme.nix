# Theme - nix eval --impure --json --expr 'builtins.attrNames ((builtins.getFlake "github:Gerg-L/spicetify-nix").legacyPackages.x86_64-linux.themes)'
{ inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  programs.spicetify = {
    theme = spicePkgs.themes.onepunch;
    # onepunch - gruvbox, starryNight, text - spotify-tui, defaultDynamic, retroBlur, hazy
  };
}
{ inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
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
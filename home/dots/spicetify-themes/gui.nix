# Standart UI theme for Spicetify.
{ inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  programs.spicetify = {
    enabledSnippets = with spicePkgs.snippets; [ sonicDancing ];
  };
}
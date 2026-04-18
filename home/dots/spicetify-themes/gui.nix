# Standart UI theme for Spicetify.
{ inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  programs.spicetify = {
    enabledExtensions = with spicePkgs.extensions; [
      powerBar # macOS bar for search. 
    ];
    enabledSnippets = with spicePkgs.snippets; [ sonicDancing ];
  };
}
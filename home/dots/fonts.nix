{ pkgs, inputs, ... }:
let
  applefonts = inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system};
in {
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [ "JetBrainsMono Nerd Font Propo" "SF Mono" ];
      serif     = [ "JetBrainsMono Nerd Font Propo" "SF Pro" ];
      monospace = [ "JetBrainsMono Nerd Font Propo" "SF Pro" ];
    };
  };
}
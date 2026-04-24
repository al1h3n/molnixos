{ pkgs, inputs, ... }: 
let
  applefonts = inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system};
in {
  home.packages = [
    applefonts.sf-pro
    applefonts.sf-pro-nerd
    applefonts.sf-mono-nerd
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [ "JetBrainsMono Nerd Font" ];
      serif     = [ "JetBrainsMono Nerd Font" ];
      monospace = [ "JetBrainsMono Nerd Font" ];
      # SF Pro Display
    };
  };
}
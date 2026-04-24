{ pkgs, inputs, ... }: {
  home.packages = [
    inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-pro-nerd
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
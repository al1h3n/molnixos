{ pkgs, inputs, variables, ... }: {
  home.packages = [
    inputs.apple-fonts.packages.${variables.system}.sf-pro
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
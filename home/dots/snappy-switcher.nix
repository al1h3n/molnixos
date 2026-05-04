# Alt + Tab manager.
{ inputs, pkgs, ... }:
let
  themeSource = "${inputs.snappy-switcher}/themes";
in {
  home = {
    packages = [ inputs.snappy-switcher.packages.${pkgs.stdenv.hostPlatform.system}.default ];
    file.".config/snappy-switcher/themes" = {
      source = themeSource;
      recursive = true;
    };
  };
}
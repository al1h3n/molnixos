{ pkgs, ... }:
let
  icons = import ./icons-lib.nix { inherit pkgs; };
in {
  home.packages = [ icons.we10x icons.mactahoe ];
  xdg.dataFile."icons/We10X-black-dark".source = "${icons.we10x}/share/icons/We10X-black-dark";
  xdg.dataFile."icons/MacTahoe".source = "${icons.mactahoe}/share/icons/MacTahoe";
}
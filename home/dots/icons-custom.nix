# Custom icons.
{ pkgs, ... }:
let
  icons = import ./icons-src.nix { inherit pkgs; };
in {
  home.packages = with icons; [ we10x mactahoe ];

  
  xdg.dataFile = {
    "icons/We10X-black-dark".source = "${icons.we10x}/share/icons/We10X-black-dark";
    "icons/MacTahoe".source = "${icons.mactahoe}/share/icons/MacTahoe";
  };
  
  gtk.iconTheme = {
    name    = "MacTahoe";
    package = icons.mactahoe;
  };
  
  # GTK 4.
  dconf.settings."org/gnome/desktop/interface".icon-theme = "MacTahoe";
}
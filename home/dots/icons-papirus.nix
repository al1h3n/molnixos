{ pkgs, ... }: {
  home.packages = [ pkgs.papirus-icon-theme ];

  gtk.iconTheme = {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
  };

  dconf.settings."org/gnome/desktop/interface".icon-theme = "Papirus-Dark";
}
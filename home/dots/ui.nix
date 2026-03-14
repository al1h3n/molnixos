# ui.nix - GTK + Qt theming
{ pkgs, ... }:
let
  icons = import ./icons-lib.nix { inherit pkgs; };
in {
  # GTK
  gtk = {
    enable = true;
    theme = {
      name = "Breeze-Dark";
      package = pkgs.kdePackages.breeze-gtk;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };

  # Qt
  qt = {
    enable = true;
    platformTheme.name = "breeze";
    style = {
      name = "breeze-dark";
      package = pkgs.kdePackages.breeze;
    };
  };

  home = {
    packages = [ icons.mactahoe pkgs.kdePackages.breeze pkgs.kdePackages.breeze-gtk ];
    sessionVariables = {
      QT_QPA_PLATFORMTHEME = "breeze";
      # QT_STYLE_OVERRIDE = "breeze-dark";
      # Not recommended by qt6ct.
      QT_FONT = "SF Pro Display:12";
      GTK_THEME = "Breeze-Dark";
    };
  };

  # Qt5/Qt6 icon theme config
  xdg.configFile."qt5ct/qt5ct.conf".text = ''
    [Appearance]
    icon_theme=MacTahoe
    style=Breeze
    color_scheme_path=/usr/share/color-schemes/BreezeDark.colors
  '';
  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    icon_theme=MacTahoe
    style=Breeze
    color_scheme_path=/usr/share/color-schemes/BreezeDark.colors
  '';
}

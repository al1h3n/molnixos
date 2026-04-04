# ui.nix - GTK + Qt theming
{ pkgs, config, ... }:
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
    gtk4 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
      theme = {
        name = "Breeze-Dark";
        package = pkgs.kdePackages.breeze-gtk;
      };
    };
  };
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };
  home.activation.createDconf = config.lib.dag.entryBefore [ "dconfSettings" ] ''
    mkdir -p $HOME/.config/dconf
  '';

  # Qt
  qt = {
    enable = true;
    # platformTheme.name = "breeze";
    platformTheme.name = "qt6ct";
    style = {
      name = "breeze-dark";
      package = pkgs.kdePackages.breeze;
    };
  };

  home = {
    sessionVariables = {
      QT_QPA_PLATFORMTHEME = "breeze";
      # QT_STYLE_OVERRIDE = "breeze-dark"; # Not recommended by qt6ct.
      QT_FONT = "SF Pro Display:12";
      GTK_THEME = "Breeze-Dark";
    };
  };

  # Packages.
  home.packages = lib.concatLists [

    # Icons.
    [ icons.we10x ]

    (with pkgs; [
      # qt6ct
      qt6.qtstyleplugin-kvantum
      qt6Packages.qt6ct

      # Breeze theme.
      kdePackages.breeze
      kdePackages.breeze-gtk
    ])
  ];

  # Qt5/Qt6 icon theme config.
  # Change to icon_theme to apply icons (look pixelated).
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

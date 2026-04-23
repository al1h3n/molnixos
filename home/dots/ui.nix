# ui.nix - GTK + Qt theming.
{ config, lib, pkgs, ... }: 
let breezeDarkColors = "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors";
in {
  # GTK
  gtk = {
    enable = true;
    theme = {
      name = "Breeze-Dark";
      package = pkgs.kdePackages.breeze-gtk;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;

    # Avoid warnings.
    gtk4.theme = config.gtk.theme;

  };
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Breeze-Dark"; # explicit, required by some apps
    };
  };

  # Qt
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    # QT_QPA_PLATFORMTHEME but for local. qtct sets to qt5ct for now.
  };

  systemd.user.sessionVariables = {
    GTK_THEME = "Breeze-Dark";
    QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
  };

  home.sessionVariables = {
    GTK_THEME = "Breeze-Dark";
    QT_FONT = "SF Pro Display:12";
  };

  # Packages.
  home.packages = lib.concatLists [
    (with pkgs.qt6Packages; [
      qt6ct
      # qtstyleplugin-kvantum # If you're using Kvantum styles.
    ])

    (with pkgs.qt5Packages; [
      qt5ct
    ])

    (with pkgs; [
      kdePackages.breeze
      kdePackages.breeze-gtk
    ])
  ];

  # Qt5/Qt6 icon theme config.
  # Change to icon_theme to apply icons (look pixelated).
  xdg.configFile = {
    "qt5ct/qt5ct.conf".text = ''
      [Appearance]
      icon_theme=MacTahoe
      style=Breeze-Dark
      color_scheme_path=${breezeDarkColors}
      custom_palette=true
    '';

    "qt6ct/qt6ct.conf".text = ''
      [Appearance]
      icon_theme=MacTahoe
      style=Breeze-Dark
      color_scheme_path=${breezeDarkColors}
      custom_palette=true
    '';
  };
}

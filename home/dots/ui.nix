# ui.nix - GTK + Qt theming (without icons).
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
    platformTheme.name = "qt6ct";
    # QT_QPA_PLATFORMTHEME but for local. qtct sets to qt5ct for now.
  };

  systemd.user.sessionVariables = {
    GTK_THEME = "Breeze-Dark";
    QT_QPA_PLATFORMTHEME = "qt6ct"; # Use lib.mkForce if you have errors.
  };

  home.sessionVariables = {
    GTK_THEME = "Breeze-Dark";
    QT_FONT = "SF Pro Display:12";
  };

  # Packages.
  home.packages =
    (with pkgs.qt6Packages; [
      qt6ct
      qtstyleplugin-kvantum # If you're using Kvantum styles.
      ])
    ++
    (with pkgs; [
    kdePackages.breeze kdePackages.breeze-gtk
    gruvbox-dark-gtk gruvbox-kvantum
    nwg-look
    ]);

  # Stylix
  # stylix = {
  #   enable = true;
  #   polarity = "dark";
  #   fonts = { # Package and name.
  #     serif = {};
  #     sansSerif = {};
  #     monospace = {};
  #     emoju = {};
  #   };
  # };
}

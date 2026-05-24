# ui.nix - GTK + Qt theming (without icons).
{ config, lib, pkgs, variables, ... }:
let breezeDarkColors = "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors";
in {
  # GTK
  gtk = {
    enable = true;
    theme = {
      name = variables.theme_gtk;
      package = pkgs.gruvbox-dark-gtk;
      # name = "Breeze-Dark";
      # package = pkgs.kdePackages.breeze-gtk;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;

    # Avoid warnings.
    gtk4.theme = config.gtk.theme;

  };
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = variables.theme_gtk; # explicit, required by some apps
    };
  };

  # Qt
  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
    # QT_QPA_PLATFORMTHEME but for local. qtct sets to qt5ct for now.
  };

  xdg.dataFile."Kvantum/Gruvbox-Dark-Brown".source = "${pkgs.gruvbox-kvantum}/share/Kvantum/Gruvbox-Dark-Brown";

  systemd.user.sessionVariables = {
    GTK_THEME = variables.theme_gtk;
    QT_QPA_PLATFORMTHEME = "qt6ct"; # Use lib.mkForce if you have errors.
    QT_QPA_PLATFORM = "wayland;xcb";
  };

  # Packages.
  home.packages =
    (with pkgs.qt6Packages; [
      qt6ct
      qtstyleplugin-kvantum # If you're using Kvantum styles.
      qtwayland # For dupeguru.
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

# ui.nix - GTK + Qt widget theming (icons live in icons*.nix).
#
# Colours are owned by Noctalia, not by this file. Enable the "GTK 3", "GTK 4"
# and "Qt" templates in Noctalia -> Settings -> Theme -> Templates; they write:
#   ~/.config/gtk-3.0/noctalia.css   imported by gtk.css below
#   ~/.config/gtk-4.0/noctalia.css   imported by gtk.css below
#   ~/.config/qt{5,6}ct/colors/noctalia.conf   selected by color_scheme_path
# The base widget theme stays declarative: change variables.theme_gtk / the
# qt6ct GUI, the palette follows the wallpaper on its own.
{ config, lib, pkgs, variables, ... }:
let
  # qt5ct and qt6ct are GUI configurators. Their config file has to stay a
  # writable regular file, otherwise every change made in the GUI is silently
  # discarded and the Noctalia palette can never be selected. So it is seeded
  # once instead of being a read-only store symlink.
  #
  # style=Fusion on purpose: Adwaita-Dark and Kvantum hardcode their own
  # colours and ignore custom_palette, so Noctalia's palette would not show up.
  # Switch it in the qt6ct GUI if you prefer a fixed style over live colours.
  qtctSeed = ct: pkgs.writeText "${ct}.conf" ''
    [Appearance]
    icon_theme=Papirus-Dark
    style=Fusion
    custom_palette=true
    color_scheme_path=${config.xdg.configHome}/${ct}/colors/noctalia.conf

    [Fonts]
    fixed="SF Mono Nerd Font"
    general="SF Mono Nerd Font"
  '';
in {
  # GTK
  gtk = {
    enable = true;
    theme = {
      name = variables.theme_gtk; # find names with nwg-look
      package = pkgs.adw-gtk3;
    };
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
      extraCss = ''@import url("noctalia.css");'';
    };
    # GTK4 ignores gtk-theme-name, it only respects user CSS.
    gtk4 = {
      theme = config.gtk.theme;
      extraCss = ''@import url("noctalia.css");'';
    };
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = variables.theme_gtk; # explicit, required by some apps
    };
  };

  # Noctalia rewrites gtk.css as a regular file when the import is missing.
  # Drop the leftovers so checkLinkTargets does not abort on them.
  home.activation.removeGtkCss = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f "${config.xdg.configHome}/gtk-3.0/gtk.css"
    rm -f "${config.xdg.configHome}/gtk-4.0/gtk.css"
  '';

  # Qt
  # "qtct" makes home-manager export QT_QPA_PLATFORMTHEME=qt5ct and install both
  # configurators. qt6ct's plugin registers the "qt5ct" key too, so that single
  # value themes Qt5 and Qt6 alike - QT_QPA_PLATFORMTHEME=qt6ct would leave
  # every Qt5 app unthemed.
  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  home.sessionVariables.QT_QPA_PLATFORM = "wayland;xcb";
  systemd.user.sessionVariables.QT_QPA_PLATFORM = "wayland;xcb";

  home.activation.seedQtct = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    lib.concatMapStringsSep "\n" (ct: ''
      if [ ! -e "${config.xdg.configHome}/${ct}/${ct}.conf" ]; then
        run install -Dm644 ${qtctSeed ct} "${config.xdg.configHome}/${ct}/${ct}.conf"
      fi
    '') [ "qt5ct" "qt6ct" ]
  );

  home.packages = with pkgs; [
    qt6Packages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtwayland # for dupeguru

    adw-gtk3
    adwaita-qt
    adwaita-qt6
    gruvbox-dark-gtk
    gruvbox-kvantum # found via XDG_DATA_DIRS, no manual symlink needed
    nwg-look
  ];
}

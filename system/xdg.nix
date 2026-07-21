{ pkgs, ... }: {
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common = {
      default = "*"; # Or *, [ "gtk" ]
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      # "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };
  };

  xdg.mime.defaultApplications = {
    "audio/*" = "mpv.desktop";
    "video/*" = "mpv.desktop";
    "image/*" = "org.gnome.gThumb.desktop";
  };
}
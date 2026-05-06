{ pkgs, ... }: {
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      common.default = [ "gtk" ]; # Or *
      # "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };
  };
}
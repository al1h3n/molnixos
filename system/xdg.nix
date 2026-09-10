{ pkgs, ... }: {
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };

  # NixOS expands these globs into every concrete MIME type, so one line covers the whole family.
  xdg.mime.defaultApplications = {
    "audio/*" = "mpv.desktop";
    "video/*" = "mpv.desktop";
    "image/*" = "geeqie.desktop";
  };
}

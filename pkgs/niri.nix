# Niri with custom path for config.
{ pkgs, ... }: {
  programs.niri.enable = true;
  systemd.user.services.niri.enableDefaultPath = false;
  environment.sessionVariables.NIRI_CONFIG = "/etc/nixos/shared/config/niri/niri.kdl";
}
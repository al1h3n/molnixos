{ pkgs, variables, ... }: {
  programs.niri.enable = true;
  environment.systemPackages = [ pkgs.xwayland-satellite ];
  environment.sessionVariables.NIRI_CONFIG = variables.niriconf;
}
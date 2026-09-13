{ pkgs, inputs, variables, ... }: {
  programs.niri = {
    enable = true;
    # niri-glass is niri 26.04 with the liquid-glass render path patched in.
    # Not cached anywhere, so the niri crate compiles locally on every bump.
    # package = inputs.niri-glass.packages.${pkgs.stdenv.hostPlatform.system}.niri-glass;
  };
  environment.systemPackages = [ pkgs.xwayland-satellite ];
  environment.sessionVariables.NIRI_CONFIG = variables.niriconf;
}

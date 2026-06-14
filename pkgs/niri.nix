# Niri with custom path for config.
{ pkgs, ... }: {
  programs.niri = {
    enable = true;
    # package = pkgs.niri.overrideAttrs (oldAttrs: {
    #   nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
    #   postInstall = (oldAttrs.postInstall or "") + ''
    #     mv $out/bin/niri $out/bin/niri-unwrapped
    #     makeWrapper $out/bin/niri-unwrapped $out/bin/niri \
    #       --add-flags "-c /etc/nixos/shared/config/niri/niri.kdl"
    #   '';
    # });
  };
  # 3. Prevent systemd from falling back to default environment paths.
  systemd.user.services.niri.enableDefaultPath = false;
  environment.sessionVariables.NIRI_CONFIG = "/etc/nixos/shared/config/niri/niri.kdl";
}
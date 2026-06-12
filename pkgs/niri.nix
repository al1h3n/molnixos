# Niri with custom path for config.
{ pkgs, ... }: {
  programs.niri = {
    enable = true;
    package = pkgs.niri.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
        mv $out/bin/niri $out/bin/niri-unwrapped
        makeWrapper $out/bin/niri-unwrapped $out/bin/niri \
          --add-flags "-c /etc/nixos/shared/config/niri/niri.kdl"
      '';
    });
  };
  # 3. Prevent systemd from falling back to default environment paths.
  systemd.user.services.niri.enableDefaultPath = false;
}
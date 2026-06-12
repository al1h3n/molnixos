# Niri with custom path for config.
{ pkgs, ... }: {
  programs.niri = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "niri-custom";
      paths = [ pkgs.niri ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        rm $out/bin/niri
        makeWrapper ${pkgs.niri}/bin/niri $out/bin/niri \
          --add-flags "-c /etc/nixos/shared/config/niri/niri.kdl"
      '';
    };
  };
  # 3. Prevent systemd from falling back to default environment paths.
  systemd.user.services.niri.enableDefaultPath = false;
}
}
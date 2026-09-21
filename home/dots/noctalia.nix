# Noctalia layers its own writable ~/.local/state/noctalia/settings.toml on top
# of this read-only config.toml, so a store symlink here is fine: GUI changes
# still persist, they just land in the state file.
{ lib, pkgs, inputs, variables, config, ... }:
let
  librepods = pkgs.callPackage ../../build/librepods-noctalia.nix {
    src = inputs.librepods-noctalia;
  };
in {
  # The patched fork supplies the status file and control verbs used by
  # harveywuk/airpods. librepods-ctl is therefore available on PATH.
  home.packages = [ pkgs.noctalia librepods ];

  systemd.user.services.librepods = {
    Unit = {
      Description = "librepods AirPods daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${lib.getExe librepods} --headless";
      Restart = "on-failure";
      RestartSec = 5;
      UMask = "0077";
      Environment = [ "QT_LOGGING_RULES=openpods.debug=false" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  xdg.configFile."noctalia/config.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink variables.noctalia5;
    force = true;
  };
}

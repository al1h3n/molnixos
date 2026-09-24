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
      # Ordered after the graphical session so PipeWire/Bluetooth are up, but
      # deliberately NOT PartOf/WantedBy=graphical-session.target: on this
      # system graphical-session.target gets torn down transiently on every
      # Hyprland<->Niri session switch (niri ships niri-shutdown.target with
      # Conflicts=graphical-session.target, and nothing keeps the target
      # "needed" once the polkit agent finishes starting - StopWhenUnneeded
      # then kills it even while Hyprland is still the active session). A
      # PartOf binding here made librepods get SIGTERM'd a few seconds/minutes
      # into every Hyprland session, which is exactly the "doesn't recognize
      # my AirPods on Hyprland" symptom. WantedBy=default.target instead ties
      # the daemon to the whole login, independent of WM session-target churn.
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${lib.getExe librepods} --headless";
      Restart = "on-failure";
      RestartSec = 5;
      UMask = "0077";
      Environment = [ "QT_LOGGING_RULES=openpods.debug=false" ];
    };
    Install.WantedBy = [ "default.target" ];
  };

  xdg.configFile."noctalia/config.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink variables.noctalia5;
    force = true;
  };
}

{ pkgs, lib, ... }:
{
  # aw-server (rust) only. The HM module's `watchers` option is deliberately
  # unused: it writes settings to $XDG_CONFIG_HOME/activitywatch/<name>/ and
  # orders the unit after default.target. awatcher reads
  # $XDG_CONFIG_HOME/awatcher/config.toml and needs a live compositor, so the
  # generated unit silently exits 0 at boot before Wayland is up.
  services.activitywatch.enable = true;

  # Window + AFK watcher for Wayland. Settings go through CLI flags.
  systemd.user.services.awatcher = {
    Unit = {
      Description = "awatcher (ActivityWatch window/AFK watcher)";
      After = [ "graphical-session.target" "activitywatch.service" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.awatcher} --idle-timeout 180 --poll-time-idle 4 --poll-time-window 1";
      # awatcher exits 0 when no compositor is reachable, so on-failure is useless.
      Restart = "always";
      RestartSec = 10;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Optional tray icon. Not required: aw-server and awatcher run on their own,
  # the web UI is at http://localhost:5600 and the browser extension talks to
  # aw-server directly. Uncomment both blocks to get the systray entry back.
  #
  # xdg.configFile."activitywatch/aw-qt/aw-qt.toml".text = ''
  #   [autostart]
  #   autostart_modules = []
  # '';
  #
  # systemd.user.services.aw-qt = {
  #   Unit = {
  #     Description = "ActivityWatch tray icon";
  #     After = [ "graphical-session.target" "activitywatch.service" ];
  #     PartOf = [ "graphical-session.target" ];
  #   };
  #   Service = {
  #     ExecStart = lib.getExe' pkgs.activitywatch "aw-qt";
  #     Restart = "on-failure";
  #     RestartSec = 10;
  #   };
  #   Install.WantedBy = [ "graphical-session.target" ];
  # };
}

{ pkgs, lib, config, ... }: {
  services.activitywatch = {
    enable = true;
    package = pkgs.activitywatch;

    watchers = {
      aw-awatcher = {
        package = pkgs.awatcher;
        executable = "awatcher";        # ← actual binary name in the store
        settings = {
          idle-timeout-seconds  = 180;
          poll-time-idle-seconds  = 4;
          poll-time-window-seconds = 1;
        };
        settingsFilename = "config.toml";
      };
    };
  };

  # Tell aw-qt to only manage itself (no watchers) via its config file.
  # The watchers are already managed by systemd via services.activitywatch.
  xdg.configFile."activitywatch/aw-qt/aw-qt.toml".text = ''
    [autostart]
    autostart_modules = []
  '';

  systemd.user.services.aw-qt = {
    Unit = {
      Description = "ActivityWatch tray icon";
      After   = [ "graphical-session.target" "activitywatch.target" ];
      PartOf  = [ "graphical-session.target" ];
    };
    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
      # No flags needed — aw-qt.toml above handles module suppression
      ExecStart    = lib.getExe' pkgs.activitywatch "aw-qt";
      Restart      = "on-failure";
      RestartSec   = "10s";
      Environment  = [ "QT_QPA_PLATFORM=wayland" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
# activitywatch.nix (home-manager module)
{ pkgs, lib, ... }:

{
  # ── Core server + watcher services ──────────────────────────────────────
  services.activitywatch = {
    enable = true;
    package = pkgs.activitywatch;   # provides aw-server-rust

    # Don't run the broken X11 watchers at all
    # Instead we use awatcher as a custom watcher entry
    watchers = {
      aw-awatcher = {
        package = pkgs.awatcher;    # pkgs.awatcher in nixpkgs-unstable
        # awatcher auto-detects Hyprland/niri/Wayland and picks the right backend
        settings = {
          # idle timeout in seconds before marking AFK
          idle-timeout-seconds = 180;
          poll-time-idle-seconds = 4;
          poll-time-window-seconds = 1;

          # optional: filter sensitive windows
          # filters = [
          #   {
          #     match-app-id  = "firefox";
          #     match-title   = ".*[Pp]rivate.*";
          #     replace-title = "Private Browsing";
          #   }
          # ];
        };
        settingsFilename = "config.toml";
      };
    };
  };

  # ── aw-qt tray icon (optional, gives you the system tray menu) ──────────
  # Must start AFTER waybar so its SNI tray is already registered.
  systemd.user.services.aw-qt = {
    Unit = {
      Description  = "ActivityWatch tray icon";
      # graphical-session means the compositor (Hyprland/niri) is up
      After        = [ "graphical-session.target" "tray.target" ];
      PartOf       = [ "graphical-session.target" ];
    };
    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
      ExecStart = "${lib.getExe' pkgs.activitywatch "aw-qt"} --no-autostart-modules";
      Restart    = "on-failure";
      RestartSec = "5s";
      Environment = [ "QT_QPA_PLATFORM=wayland" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
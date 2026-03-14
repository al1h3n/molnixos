# polkit.nix - Polkit GNOME authentication agent autostart.
# Replaces exec-once in hyprconfig for NixOS (path differs from Arch).
{ pkgs, ... }: {
  systemd.user.services.polkit-gnome = {
    Unit = {
      Description = "GNOME Polkit authentication agent";
      After = "graphical-session.target";
      Wants = "graphical-session.target";
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}

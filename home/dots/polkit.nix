# polkit.nix - Polkit GNOME authentication agent autostart.
# Replaces exec-once in hyprconfig for NixOS (path differs from Arch).
{ pkgs, ... }: {
  systemd.user.services.polkit-gnome = {
    # wantedBy here (top-level) actually creates the symlink to enable the service.
    # Install.WantedBy alone does NOT enable it in home-manager.
    wantedBy = [ "graphical-session.target" ];

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
  };
}
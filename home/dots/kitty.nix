{ config, pkgs, lib, variables, ... }: {
  xdg.configFile = {
    "kitty/kitty.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink variables.kitty;
      force = true;
    };
  };

  home.packages = [ pkgs.inotify-tools ];

  # Pushes Noctalia's regenerated kitty theme into every open kitty window
  # live, instead of colors only updating on the next manual reload/restart.
  # See scripts/colors/noctalia-live-colors.sh for why a plain file watch
  # isn't enough (Noctalia atomically replaces the theme file).
  systemd.user.services.noctalia-live-colors = {
    Unit = {
      Description = "Push Noctalia's kitty theme into running kitty windows live";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.bash} ${variables.lshared}/scripts/colors/noctalia-live-colors.sh";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
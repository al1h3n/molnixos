{ pkgs, ... }: {
  services = {
    activitywatch = {
      enable = true;
      watchers = {
        aw-watcher-window = {
          package = pkgs.aw-watcher-window-wayland;
          executable = "aw-watcher-window-wayland";
        };
        aw-watcher-afk = {
          package = pkgs.activitywatch;
          executable = "aw-watcher-afk";
        };
      };
    };
  };
}
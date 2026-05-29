{ config, variables, ... }: {
  xdg.configFile = {
    "wezterm/wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink variables.wezterm;
  };
}
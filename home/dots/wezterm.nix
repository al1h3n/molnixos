{ config, lib, variables, ... }: {
  xdg.configFile = {
    "wezterm/wezterm.lua" = lib.mkForce { source = config.lib.file.mkOutOfStoreSymlink variables.wezterm; };
  };
}
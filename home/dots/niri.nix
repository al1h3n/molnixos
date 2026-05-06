{ config, variables, ... }: {
  xdg.configFile = {
    "niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink variables.niri;
  };
}
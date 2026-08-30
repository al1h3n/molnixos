{ config, variables, ... }: {
  xdg.configFile = {
    "kitty/kitty.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink variables.kitty;
      force = true;
    };
  };
}
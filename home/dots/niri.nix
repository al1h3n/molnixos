{ variables, ... }: {
  xdg.configFile."niri" = {
    source = variables.niri; # config.lib.file.mkOutOfStoreSymlink
    recursive = true;
  };
}

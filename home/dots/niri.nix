{ ... }: {
  programs.niri = {
    enable = true;
  };
  xdg.configFile = {
    "niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink variables.niri;
  };
}
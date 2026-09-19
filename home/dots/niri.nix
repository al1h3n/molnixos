{ variables, pkgs, config, ... }: {
  home.packages = [ pkgs.nirimod ];
  xdg.configFile."niri" = {
    source = config.lib.file.mkOutOfStoreSymlink variables.niri;
    recursive = true;
  };
}
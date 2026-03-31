{ pkgs, config, variables, ... }: {
  xdg.configFile."peazip/conf.txt"= {
    source = variables.peazip;
    force = true;
  };
}
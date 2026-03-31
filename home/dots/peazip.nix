{ pkgs, config, variables, ... }: {
  xdg.configFile."dark".text = "";
  xdg.configFile."peazip/conf.txt"= {
    source = variables.peazip;
    force = true;
  };
}
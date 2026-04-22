{ variables, ... }: {
  xdg.configFile."peazip/dark".text = "";
  # xdg.configFile."peazip/conf.txt"= {
  #   source = variables.peazip;
  #   force = true;
  # };
}
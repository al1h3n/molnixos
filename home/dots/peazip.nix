{ variables, ... }: {
  xdg.configFile."dark".text = "";
  # xdg.configFile."peazip/conf.txt"= {
  #   source = variables.peazip;
  #   force = true;
  # };

  xdg.configFile."peazip/conf.txt".text = builtins.replaceStrings
    [ "~/.local/share/molnios" ][ variables.lshared ]
    (builtins.readFile variables.peazip);
}
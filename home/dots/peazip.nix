# Unfortunately, you'll need to manually copy conf.txt to directory.
# ~/.config/peazip/dark doesn't work either, only bin path.

{ pkgs, variables, ... }: {
  # xdg.configFile."peazip/conf.txt"= {
  #   source = variables.peazip;
  #   force = true;
  # };

  home.packages = [
    (pkgs.symlinkJoin {
      name = "peazip-dark";
      paths = [ pkgs.peazip ];
      postBuild = ''
        touch $out/bin/dark
      '';
    })
  ];
}
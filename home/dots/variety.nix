{ pkgs, variables, ... }: {
  home.packages = [ pkgs.variety ];
  xdg.configFile = {
    "variety/scripts/set_wallpaper.sh" = {
      executable = true;
      text = ''
        # Variety passes the wallpaper path as $1
        ${pkgs.waypaper}/bin/waypaper --wallpaper "$1" --backend awww --restore
      '';
    };

    "variety/variety.conf" = {
      text = ''
        [General]
        set_wallpaper_script = ~/.config/variety/scripts/set_wallpaper.sh
      '';
      # /home/${variables.username}
    };
  };
}
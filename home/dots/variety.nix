{ pkgs, lib, variables, ... }: {
  home.packages = [ pkgs.variety ];
  # xdg.configFile = {
  #   "variety/scripts/set_wallpaper.sh" = {
  #     executable = true;
  #     text = ''
  #       # Variety passes the wallpaper path as $1
  #       ${pkgs.waypaper}/bin/waypaper --wallpaper "$1" --backend awww --restore
  #     '';
  #   };

   home.activation.varietySetterScript = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p ~/.config/variety/scripts
      cat > ~/.config/variety/scripts/set_wallpaper.sh << 'EOF'
  #!/bin/sh
  ${pkgs.waypaper}/bin/waypaper --wallpaper "$1" --backend swww --restore
  EOF
      chmod +x ~/.config/variety/scripts/set_wallpaper.sh
    '';

    xdg.configFile."variety/variety.conf" = {
      text = ''
        [General]
        set_wallpaper_script = ~/.config/variety/scripts/set_wallpaper.sh
      '';
      # /home/${variables.username}
    };
  }
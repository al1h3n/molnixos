{ pkgs, variables, ... }: {
  home.packages = [ pkgs.mangohud ]; # FPS counter, enable manually. Breaks WaylandCraft's Rust init, keep it off for that instance.
  xdg.configFile."MangoHud/MangoHud.conf"= {
    source = variables.mangohud;
    force = true;
  };
}
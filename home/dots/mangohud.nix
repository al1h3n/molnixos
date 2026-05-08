{ variables, ... }: {
  xdg.configFile."MangoHud/MangoHud.conf"= {
    source = variables.mangohud;
    force = true;
  };
}
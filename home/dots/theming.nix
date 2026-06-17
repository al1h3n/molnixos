{ variables, ... }: {
  xdg.configFile."matugen/config.toml".source = variables.matugen;
  xdg.configFile."wallust/wallust.toml".source = variables.wallust;
}
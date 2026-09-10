{ config, lib, variables, ... }: {
  xdg.configFile = {
    "matugen/config.toml".source = variables.matugen;
    "wallust/wallust.toml".source = variables.wallust;
    "matugen/templates/colors.sh".source =
      config.lib.file.mkOutOfStoreSymlink "${variables.shared}/matugen/templates/colors.sh";
    "matugen/templates/colors.vim".source =
      config.lib.file.mkOutOfStoreSymlink "${variables.shared}/matugen/templates/colors.vim";
  };

  home.activation.removeMatugenTemplates = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f "${config.xdg.configHome}/matugen/templates/colors.sh"
    rm -f "${config.xdg.configHome}/matugen/templates/colors.vim"
  '';
}

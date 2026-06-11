{ variables, ... }: {
  xdg.configFile = {
    "matugen/templates/colors.sh".source  = sym "matugen/templates/colors.sh";
    "matugen/templates/colors.vim".source = sym "matugen/templates/colors.vim";
    # fish and sequences already there or can be added the same way
  };
}
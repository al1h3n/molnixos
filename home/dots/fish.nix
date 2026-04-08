{ pkgs, variables, ... }: {
  programs.fish = {
    enable = true;
    initContent = ''
      source ${toString variables.fish}
      source ${toString variables.fish_theme}
    '';
  };
  home = {
    packages = with pkgs.fishPlugins;[
      tide # Theme for fish.
    ];
  };
  
}
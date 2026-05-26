{ pkgs, variables, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      source ${toString variables.fish}
    '';
  };
  home = {
    packages = with pkgs.fishPlugins;[
      tide # Theme for fish.
      fzf-fish autopair sponge
    ];
  };

}
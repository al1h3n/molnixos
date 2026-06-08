{ pkgs, variables, ... }: {
  programs.zsh = {
    enable = true;
    initContent = ''
      source ${toString variables.zsh}
      source ${toString variables.zsh_theme}
    '';
  };
  home = {
    packages = with pkgs;[
      zoxide
      sheldon # zinit
    ];
  };
  xdg.configFile."sheldon/plugins.toml"= {
    source = variables.sheldon;
  };
}
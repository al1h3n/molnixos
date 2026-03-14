{ config, pkgs, variables, ... }: 
let
  zsh-shift-select = builtins.fetchTarball {
    url = "https://github.com/jirutka/zsh-shift-select/archive/master.tar.gz";
  };
in {
  programs.zsh = {
    enable = true;
    enableCompletion = false; # Removing ZSH auto plugin for zsh-autocompletion.
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-shift-select";
        src = zsh-shift-select;
        file = "zsh-shift-select.plugin.zsh";
      }
      {
      name = "zsh-autocomplete";
      src = pkgs.zsh-autocomplete;
      file = "share/zsh-autocomplete/zsh-autocomplete.plugin.zsh";
      }
    ];
    initContent = ''
      source ${toString variables.zsh}
      source ${toString variables.zsh_theme}
    '';
  };
  home = {
    packages = with pkgs;[
      zsh-autocomplete
    ];
    # file.".p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink variables.zsh_theme;
    # file.".zshrc".source = config.lib.file.mkOutOfStoreSymlink variables.zsh;
  };
  
}
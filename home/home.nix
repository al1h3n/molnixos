# home.nix
# Home-manaager is used to manage user configuration, such as software and dotfiles. This file is imported in configuration.nix, and is used to apply the user configuration.

{ variables, ... }: {
  imports =[
    ./packages.nix
    ./dotfiles.nix
    ./variable-links.nix
  ];
  home.stateVersion = variables.version;
}
# home.nix
# Home-manaager is used to manage user configuration, such as software and dotfiles. This file is imported in configuration.nix, and is used to apply the user configuration.

{ variables, ... }: {
  imports =[
    ./user.nix
    ./dotfiles.nix
    ./cleaner.nix
    # ./variable-links.nix
  ];
  home.stateVersion = variables.version;
}
# Sample file for assigning dotfiles.
{ config, pkgs, lib, variables, ... }: {
  # pkgs if installing somethings, config and lib - check in web
  xdg.configFile."folder".source = config.lib.file.mkOutOfStoreSymlink "${variables.custom}";
  # Change "folder" to location in ~/.config and use variables.nix to set the folder where config file is.
}
# Dotfiles for all the apps.
{ ... }:
let
  path = ./dots;
  dots = [
    "cursor"
    "fonts"
    "ui"
    "icons"
    "firefox"
    "zsh"
    "feh"
    "hyprland"
    "qbittorrent"
    "polkit"
    # "sddm"
    # "art"
    # "gaming"

  ];
in {
  imports = map (name: path + "/${name}.nix") dots;
}
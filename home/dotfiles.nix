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
    "thunar"
    "peazip"
    "prismlauncher"
    "hyprland"
    "qbittorrent"
    # "polkit-hypr"
    "waypaper"
    "rofi"
    # "sddm"
    "virt-manager"
    "spicetify"
  ];
in {
  imports = map (name: path + "/${name}.nix") dots;
}
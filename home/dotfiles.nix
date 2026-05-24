# Dotfiles for all the apps.
{ ... }:
let
  path = ./dots;
  dots = [
    "cursor"
    "fonts"
    "ui"
    "icons" "icons-papirus" # "icons-custom"
    "firefox"
    "zsh"
    "feh"
    "thunar"
    "peazip"
    "prismlauncher"
    "hyprland"
    "snappy-switcher"  # Only works with hyprland.
    "niri"
    "window-manager"
    "qbittorrent"
    # "polkit-hypr"
    "waypaper"
    "rofi"
    # "sddm"
    "virt-manager"
    "spicetify"
    "lazyvim"
    "yazi"
    # "variety"
    # "ollama"
    "associations"
    "activity-watch"
  ];
in {
  imports = map (name: path + "/${name}.nix") dots;
}
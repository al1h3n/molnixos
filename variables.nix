# variables.nix
# Change what you need.

rec {

  version = "25.11";
  channel = "stable";
  kernel = "zen";

  username = "al1h3n";
  host = "MolniPC";
  os_name = "nix";
  system = "x86_64-linux";
  os_name_custom = "MolnixOS";

  zone = "Asia/Almaty";
  
  shared_root = /etc/nixos/shared;
  shared = shared_root + "/config"; # Source dotfiles folder.
  lshared = "/home/${username}/.local/share/molnios"; # Local shared firectory for all OS, reccomended to use.
  media = lshared + "/molnios-media/wallpapers"; # ! CHECK
  hosts = "${shared}/hosts";

  cursor_name = "clay_white";
  cursors_dir = shared_root + "/cursors"; 
  cursor = cursors_dir + "/${cursor_name}";
  browser = "firefox";
  icons = "${shared}/icons/MacTahoe-dark";
  theme_gtk = "Breeze-Dark";

  zsh = "${shared}/.zshrc";
  zsh_theme = "${shared}/.p10k.zsh";

  dunst = "${shared}/dunst";
  fastfetch = "${shared}/fastfetch.jsonc";
  fastfetch_ascii = "${shared}/fastfetch-ascii";

  feh = "${shared}/feh";

  hyprland = "${shared}/hyprconfig";
  hyprpaper = "${shared}/hyprpaper";
  hyprlock = "${shared}/hyprlock"; 
  rofi = "${shared}/rofi";

  kitty = "${shared}/kitty";
  kitty_style = "${shared}/kittystyle";

  ly = "${shared}/ly";
  qbittorrent = "${shared}/qbittorrent";

  sddm = "${shared}/sddm";
  swaync = "${shared}/swaync";
  swaync_style = "${shared}/swayncstyle";

  waypaper = "${shared}/waypaper";
  waypaper_style = "${shared}/waypaperstyle";

}
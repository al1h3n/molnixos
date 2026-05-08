# variables.nix
# Change what you need.

rec {

  version = "26.05";
  channel = "unstable";
  kernel = "zen";

  username = "al1h3n";
  host = "MolniPC";
  os_name_custom = "MolnixOS";

  zone = "Asia/Almaty";
  
  shared_root = "/etc/nixos/shared"; 
  shared = shared_root + "/config"; # Source dotfiles folder.

  lshare = "/home/${username}/.local/share";
  lshared = "${lshare}/molnios"; # Local shared firectory for all OS, reccomended to use.
  media = "${lshared}/molnios-media/wallpapers"; # ! CHECK

  cursor_name = "clay_white";
  cursors_dir = shared_root + "/cursors"; 
  cursor = cursors_dir + "/${cursor_name}";
  icons = "${shared}/icons/MacTahoe-dark";
  theme_gtk = "Breeze-Dark";

  browser = "firefox";
  hosts = "${shared}/hosts";

  zsh = "${shared}/.zshrc";
  zsh_theme = "${shared}/.p10k.zsh";

  dunst = "${shared}/dunst";
  fastfetch = "${shared}/fastfetch.jsonc";
  fastfetch_ascii = "${shared}/fastfetch-ascii";

  feh = "${shared}/feh";

  hyprland = "${shared}/hyprland-monolithic/hypr.conf";
  hyprpaper = "${shared}/hyprpaper";
  hyprlock = "${shared}/hyprlock"; 
  rofi = "${shared}/rofi.rasi";

  niri = "${shared}/niri.kdl";

  kitty = "${shared}/kitty";
  kitty_style = "${shared}/kittystyle";

  ly = "${shared}/ly";
  qbittorrent = "${shared}/qbittorrent.ini";

  sddm = "${shared}/sddm.conf";
  swaync = "${shared}/swaync.json";
  swaync_style = "${shared}/swaync-style.css";

  waypaper = "${shared}/waypaper.ini";
  waypaper_style = "${shared}/waypaperstyle.css";

  peazip = "${shared}/peazip.cfg";
  prismlauncher = "${shared}/prismlauncher.cfg";
  spicetify = "${shared}/spicetify";

  fish = "${shared}/config.fish";
  fish_theme = "${shared}/tide.fish";

  mangohud = "${shared}/mangohud-gaming.conf";
}
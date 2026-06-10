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
  theme_gtk = "adw-gtk3-dark"; # gruvbox-dark

  browser = "firefox";
  hosts = "${shared}/hosts";

  zsh = "${shared}/zsh/.zshrc";
  zsh_theme = "${shared}/zsh/.p10k.zsh";
  sheldon = "${shared}/zsh/sheldon.toml";

  dunst = "${shared}/dunst";
  fastfetch = "${shared}/fastfetch.jsonc";
  fastfetch_ascii = "${shared}/fastfetch-ascii";

  feh = "${shared}/feh";

  hyprland_monolithic = "${shared}/hyprland-monolithic/hypr.conf";
  hyprland = "${shared}/hyprland/hyprland.lua";
  hyprpaper = "${shared}/hyprpaper";
  hyprlock = "${shared}/hyprlock";
  rofi = "${shared}/rofi.rasi";

  niri = "${shared}/niri";
  niriconf = "${niri}/niri.kdl";

  kitty = "${shared}/kitty/kitty.conf";
  wezterm = "${shared}/wezterm/wezterm.lua";

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

  fish = "${shared}/fish/config.fish";

  mangohud = "${shared}/mangohud-benchmark.conf";
  yazi = "${shared}/yazi";
}
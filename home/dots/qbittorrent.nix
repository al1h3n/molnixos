# qbittorrent.nix
{ pkgs, config, variables, ... }: 
let
  fetchCatpuccin = name: builtins.fetchurl "https://github.com/catppuccin/qbittorrent/releases/latest/download/catppuccin-${name}.qbtheme";
  frappe = fetchCatpuccin "frappe";
  macchiato = fetchCatpuccin "macchiato";
  mocha = fetchCatpuccin "mocha";

  fetchMica = name: builtins.fetchurl "https://github.com/witalihirsch/qBitTorrent-fluent-theme/releases/latest/download/defaulticons-fluent-${name}-no-mica.qbtheme";
  fluent-light = fetchMica "light";
  fluent-dark = fetchMica "dark";
in {
  home.packages = [ pkgs.qbittorrent ];
  xdg.configFile."qBittorrent/qBittorrent.conf"= {
    source = variables.qbittorrent;
    force = true;
  };

  # Themes.
  xdg.configFile."qBittorrent/themes/catppuccin-frappe.qbtheme".source = frappe;
  xdg.configFile."qBittorrent/themes/catppuccin-macchiato.qbtheme".source = macchiato;
  xdg.configFile."qBittorrent/themes/catppuccin-mocha.qbtheme".source = mocha;
  xdg.configFile."qBittorrent/themes/fluent-light.qbtheme".source = fluent-light;
  xdg.configFile."qBittorrent/themes/fluent-dark.qbtheme".source = fluent-dark;
}
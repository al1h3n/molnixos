# qbittorrent.nix
{ pkgs, config, variables, ... }: 
let
  fetchCatpuccin = name: builtins.fetchurl "https://github.com/catppuccin/qbittorrent/releases/latest/download/catppuccin-${name}.qbtheme";vpn
  frappe = fetchCatpuccin "frappe";
  macchiato = fetchCatpuccin "macchiato";
  mocha = fetchCatpuccin "mocha";

  fetchMica = name: builtins.fetchurl "https://github.com/witalihirsch/qBitTorrent-fluent-theme/releases/latest/download/defaulticons-fluent-${name}-no-mica.qbtheme";
  fluent-light = fetchMica "light";
  fluent-dark = fetchMica "dark";
in {
  home.packages = [ pkgs.qbittorrent-enhanced ];
  xdg.configFile."qBittorrent/qBittorrent.conf"= {
    source = variables.qbittorrent;
    force = true;
  };

  # Themes.
  xdg.configFile = {
    "qBittorrent/themes/catppuccin-frappe.qbtheme".source = frappe;
    "qBittorrent/themes/catppuccin-macchiato.qbtheme".source = macchiato;
    "qBittorrent/themes/catppuccin-mocha.qbtheme".source = mocha;
    "qBittorrent/themes/fluent-light.qbtheme".source = fluent-light;
    "qBittorrent/themes/fluent-dark.qbtheme".source = fluent-dark;
  };
}
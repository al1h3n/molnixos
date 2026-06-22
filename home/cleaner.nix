# Restores MolniOS dotfile symlinks clobbered by home-manager activation.
{ config, lib, ... }:
let
  home   = config.home.homeDirectory;
  shared = "/etc/nixos/shared";
  guarded = [
    "gtk-3.0/settings.ini"
    "gtk-4.0/settings.ini"
    "gtk-3.0/gtk.css"
    "gtk-4.0/gtk.css"
    "yazi/theme.toml"
    "wezterm/wezterm.lua"
  ];
in
{
  home.activation.molniosGuard = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    lib.concatStrings (map (rel: ''
      _src="${shared}/.config/${rel}"
      _dst="${home}/.config/${rel}"
      if [ -e "$_src" ]; then
        run rm -f "$_dst.backup" "$_dst"
        run ln -sf "$_src" "$_dst"
      fi
    '') guarded)
  );
}
# icons.nix - integrates icons into QT/GTK themes.
{ pkgs, ... }: {
  home.packages = with pkgs; [
    icon-library
  ];
}
# polkit.nix - Polkit configuration.
# Switch between polkit-hypr.nix and polkit-gnome.nix by commenting/uncommenting.
{ ... }: {
  imports = [
    ./polkit-hypr.nix
    # ./polkit-gnome.nix
  ];

  security.polkit.enable = true;
}
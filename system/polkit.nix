# polkit.nix - Polkit configuration.
# Switch between polkit-hypr.nix and polkit-gnome.nix by commenting/uncommenting.
{ ... }: {
  imports = [
    # ./packages/polkit-gnome.nix
  ];

  security.polkit.enable = true;
}
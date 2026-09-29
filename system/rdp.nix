# Uses expose.nix as well.
{ ... }: {
  # Niri/Hyprland support Wayland screencopy without DRM/KMS privileges.
  # Sunshine's ports are allowed only on tailscale0 in expose.nix.
  services.sunshine.enable = true;
}

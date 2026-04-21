# Use warp-cli connect/disconnect when "nixos-rebuild switch" isn't working.
{ pkgs, ... }: {
  services.cloudflare-warp.enable = true;
  environment.systemPackages = [ pkgs.cloudflare-warp ];
}
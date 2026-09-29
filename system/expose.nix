# Expose your IP via TailScale.
{ config, ... }: {
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
    checkReversePath = "loose";
  };
  # Tailscale - expose your port.
  services.tailscale.enable = true;
}
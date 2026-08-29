# dns.nix - Custom DNS configuration using Quad9.
# Quad9 filters malicious domains by default.
# When WARP is enabled -> WARP's DNS, when disabled -> these ones.
{ ... }: {
  networking = {
    nameservers = [
      # Cloudflare.
      "1.1.1.3"
      "1.0.0.3"
      "2606:4700:4700::1113"
      "2606:4700:4700::1003"

      # QuadDNS.
      # "9.9.9.9"
      # "149.112.112.112"
      # "2620:fe::fe"
      # "2620:fe::9"
    ];

    # Prevent DHCP from overriding your DNS.
    dhcpcd.extraConfig = "nohook resolv.conf";

    # If you use NetworkManager (nm-applet suggests you do).
    networkmanager.dns = "none";
  };
}
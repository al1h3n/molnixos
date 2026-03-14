# dns.nix - Custom DNS configuration using Quad9.
# Quad9 filters malicious domains by default.
{ ... }: {
  networking = {
    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];

    # Prevent DHCP from overriding your DNS.
    dhcpcd.extraConfig = "nohook resolv.conf";

    # If you use NetworkManager (nm-applet suggests you do).
    networkmanager.dns = "none";
  };

  # Write resolv.conf directly so it's never overwritten.
  environment.etc."resolv.conf" = {
    text = ''
      nameserver 9.9.9.9
      nameserver 149.112.112.112
      nameserver 2620:fe::fe
      nameserver 2620:fe::9
    '';
    mode = "0444"; # Read-only so nothing can overwrite it.
  };
}
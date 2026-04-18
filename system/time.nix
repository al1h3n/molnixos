{ ... }: {
  # Disable timesyncd first (they conflict)
  services.timesyncd.enable = false;

  services.chrony = {
    enable = true;
    servers = [
      "pool.ntp.org"
      "time.cloudflare.com"
    ];
    extraConfig = ''
      rtconutc off        # RTC is in local time, not UTC
      makestep 1.0 3      # Step clock immediately if off by >1s (first 3 updates)
      rtcsync             # Sync RTC from system clock periodically
    '';
  };
}
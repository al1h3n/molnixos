{ ... }: {
  time.hardwareClockInLocalTime = true;

  # Disable timesyncd first (conflicts with chrony)
  services.timesyncd.enable = false;

  services.chrony = {
    enable = true;
    servers = [ "pool.ntp.org" "time.cloudflare.com" ];
    extraConfig = ''
      makestep 1.0 3
    ''; # rtcountc before.
  };
}
{ ... }: {
  # Disable timesyncd first (they conflict)
  services.timesyncd.enable = false;

  services.chrony = {
    enable = true;
    servers = [ "pool.ntp.org" "time.cloudflare.com" ];
    extraConfig = ''
      rtconutc
      makestep 1.0 3
      rtcsync
    '';
  };
}
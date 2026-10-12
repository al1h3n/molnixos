{ ... }: {
  services.ratbagd.enable = true;
  systemd.services.ratbagd = {
    after = [ "systemd-udev-settle.service" ];
    wants = [ "systemd-udev-settle.service" ];
  };
}

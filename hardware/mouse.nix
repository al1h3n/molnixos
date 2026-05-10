{ pkgs, ... }: {
  services.ratbagd.enable = true;
  system.activationScripts.udevTriggerUsb.text = "${pkgs.systemd}/bin/udevadm trigger --action=add --subsystem-match=usb";
  systemd.services.ratbagd = {
    after = [ "systemd-udev-settle.service" ];
    wants = [ "systemd-udev-settle.service" ];
  };
}
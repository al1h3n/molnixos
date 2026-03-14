{ pkgs, ... }: {
  services.ratbagd.enable = true;

  system.activationScripts.udevTriggerUsb = {
    text = ''
      ${pkgs.udev}/bin/udevadm trigger --action=add --subsystem-match=usb
    '';
    deps = [];
  };

  systemd.services.ratbagd = {
    after = [ "systemd-udev-settle.service" ];
    wants = [ "systemd-udev-settle.service" ];
  };
}
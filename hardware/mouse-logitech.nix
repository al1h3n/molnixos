{ ... }: {
  # Load the receiver/paired-device drivers in stage 1, avoiding the boot-time
  # hid-generic -> logitech-djreceiver handoff that can leave the G903 undetected.
  boot.initrd.kernelModules = [ "hid-logitech-dj" "hid-logitech-hidpp" ];
}
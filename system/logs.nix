{ ... }: {
  boot = {
    consoleLogLevel = 4;
    initrd.verbose = false;
    # kernelParams = [
    #   "quiet"
    #   "rd.systemd.show_status=false"
    #   "rd.udev.log_level=4"
    #   "udev.log_priority=4"
    #   "systemd.show_status=auto"
    # ];
  };
}
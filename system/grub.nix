{ ... }: {
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
    extraConfig = ''
      GRUB_DISABLE_OS_PROBER=false
    '';
  };
}
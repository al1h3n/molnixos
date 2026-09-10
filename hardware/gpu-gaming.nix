{ ... }: {
  boot.kernel.sysctl = {
    "vm.swappiness" = 10; # Plenty of RAM, keep the swapfile for hibernation
    "vm.vfs_cache_pressure" = 50;
  };
}
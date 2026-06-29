{ variables, ... }: {
  swapDevices = [ { device = "/var/lib/swapfile"; size = variables.ram_size * 1024; } ];
}
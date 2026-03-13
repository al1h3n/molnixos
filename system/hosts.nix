{ variables, ... }: {
  networking.extraHosts = builtins.readFile variables.hosts;
}
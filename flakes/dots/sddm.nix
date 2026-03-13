# SDDM display manager for login into system.
{ variables, ... }: {
  services.displayManager.sddm.enable = true;
  environment.etc."sddm.conf".source = variables.sddm;
}
{ ... }: {
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;   # Grants required access for Wayland stream capture
    openFirewall = true;  # Automatically configures the system firewall ports
  };

  # 3. For hardware input layer mapping hooks
  hardware.uinput.enable = true;
}
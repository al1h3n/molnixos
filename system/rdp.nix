{ ... }: {
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;   # Grants required access for Wayland stream capture
    openFirewall = true;  # Automatically configures the system firewall ports
  };

  # This allows Sunshine to pass virtual keyboard/mouse commands back to Hyprland/Niri
  users.users.YOUR_USERNAME_HERE = {
    extraGroups = [ "uinput" ];
  };

  # 3. For hardware input layer mapping hooks
  hardware.uinput.enable = true;
}
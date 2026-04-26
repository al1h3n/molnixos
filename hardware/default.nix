# Default hardware configurations.
{ pkgs, lib, variables, ... }: {
  # Main.
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };
  

  # CPU.
  hardware.cpu = {
    amd.updateMicrocode = true;
    intel.updateMicrocode = true;
  };

  # Audio - PipeWire.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;  # For 32-bit apps like Steam
    pulse.enable = true;       # PulseAudio compatibility
    jack.enable = true;        # JACK compatibility for pro audio
  };
  security.rtkit.enable = true; # Real-time priority for audio

  # Bluetooth.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;   # Enables battery level reporting
    };
  };
  services.blueman.enable = true;

  # Wi-Fi.
  hardware.wirelessRegulatoryDatabase = true;
  networking = {
    wireless.enable = lib.mkForce false; # Disable wpa_supplicant, conflicts with networkmanager.
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        powersave = false;
      };
    };
  };

  # NetworkManager packages.
  environment.systemPackages = with pkgs; [
    networkmanagerapplet  # nm-applet tray icon.
    libvdpau-va-gl # For spicetify GPU acceleration.
  ];

  # GPU.
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Add user to groups.
  users.users.${variables.username} = {
    extraGroups = [
      "networkmanager"  # Required to manage wifi without sudo
      "bluetooth"
      "audio"
      "video"
    ];
  };
}
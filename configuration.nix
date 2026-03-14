# configuration.nix - used tonybtw.com/tutorial/nixos-from-scratch
# Definitions: lambda - function without a name (literally any.nix file)
{ config, lib, pkgs, ... }:

let
  variables = import ./variables.nix;

in {
  # 1. Import files.
  imports = [
      # 1.1. Base configuration.
      ./hardware-configuration.nix
      ./hardware/hardware-basic.nix

      # 1.2. GPU/iGPU.
      ./hardware/nvidia.nix # Choose or adjust GPU configuration (custom folder)
    
      # 1.3. Updating schedule.
      ./system/updates.nix

      # 1.4. System files.
      ./system/hosts.nix 
      ./system/autolaunch.nix
      ./system/sudo.nix
      ./system/ly.nix
      ./system/dns.nix
    ];
    
  
  # 2. Experimental features and session variables.
  _module.args.variables = variables; # Add variable to NixOS modules (system-wide).
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # 3. System configuration (hardware).
  system.stateVersion = variables.version;
  networking.hostName = variables.host;
  boot = {
    kernelPackages = pkgs."linuxPackages_${variables.kernel}";
    supportedFilesystems = [ "ntfs" ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
        extraConfig = ''
          GRUB_DISABLE_OS_PROBER=false
        '';
      };
    };
  };

systemd.settings.Manager = {
  DefaultTimeoutStopSec = "10s";
};

  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
  };

  # 4. Individual user configuration (software + informaiton).
  time = {
    timeZone = variables.zone;
    hardwareClockInLocalTime = true;
  };
  users = {
    defaultUserShell = pkgs.zsh;
    users.${variables.username} = {
      description = "User account created by MolnixOS configuration.";
      isNormalUser = true;
      extraGroups = [ "wheel" "plugdev" "storage" "optical" "input" ];
      shell = pkgs.zsh;
    };
  };

  # virtualization.docker.enable = true;

  services = {
    displayManager.ly.enable = true;

    gvfs.enable = true;
    udisks2.enable = true;
    tumbler.enable = true; # Thumbnails.

    fstrim = { # SSD perfomance.
      enable = true;
      interval = "daily";
    };
  };

  programs = {
    git.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    zsh.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-volman
        thunar-archive-plugin
      ];
    };
    # For GVFS
    dconf.enable = true;
    xfconf.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment = {
    variables = {
      __VERSION = config.system.nixos.version;
      __STATE = config.system.stateVersion;
      SHARED_PATH = variables.shared;
      SHARED_MEDIA_PATH = variables.media; # Wallpapers.
      L_PATH = variables.lshared;

      WLR_NO_HARDWARE_CURSORS = "1"; # If your cursor becomes invisible
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINTS = "auto";
      NVD_BACKEND = "direct";

      JAVA_HOME = "${pkgs.temurin-bin-21}";

      GTK_THEME = variables.theme_gtk;
    };

    systemPackages = with pkgs; [
      # Programming compilers.
      gcc python3 pipx temurin-bin-8 temurin-bin-21 temurin-bin-25
    
      # Main tools.
      git openssh font-manager libnotify killall
      fastfetch btop neovim
    ];
  };

  fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
  ];
}
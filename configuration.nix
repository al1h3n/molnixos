# configuration.nix - used tonybtw.com/tutorial/nixos-from-scratch
# Definitions: lambda - function without a name (literally any.nix file)
{ config, lib, pkgs, inputs, ... }:

let
  variables = import ./variables.nix;
  applefonts = inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system};
in {
  # 1. Import files.
  imports = [
      # Build.
      ./build/github.nix

      # Hardware.
      ./hardware-configuration.nix
      ./hardware
      ./hardware/mouse.nix
      ./hardware/nvidia # GPU configuration.
      # ./hardware/vmware.nix
      # ./hardware/amd.nix
      ./hardware/gpu-gaming.nix # If you're not a gamer disable it.
      # ./hardware/swap.nix

      # Pkgs
      ./pkgs/doas.nix
      ./pkgs/hyprland.nix
      ./pkgs/minegrub.nix
      ./pkgs/niri.nix
      # ./pkgs/plasma.nix
      # ./pkgs/gnome.nix
      # ./pkgs/xfce.nix

      # System.
      ./system/updates.nix
      ./system/grub.nix
      ./system/ly.nix
      ./system/logs.nix
      ./system/hosts.nix
      ./system/autolaunch.nix
      ./system/sudo.nix
      ./system/dns.nix
      ./system/time.nix
      ./system/polkit.nix
      ./system/virtualization.nix
      ./system/xdg.nix
      ./system/vpn.nix
      ./system/executables.nix
      ./system/gaming.nix
      ./system/coding.nix
      ./system/git.nix
      ./system/rdp.nix
    ];


  # 2. Experimental features and session variables.
  _module.args.variables = variables; # Add variable to NixOS modules (system-wide).
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # 3. System configuration (hardware).
  system.stateVersion = variables.version;
  networking.hostName = variables.host;
  boot = {
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
    # kernelPackages = pkgs."linuxPackages_${variables.kernel}";
    supportedFilesystems = [ "ntfs" ];
    loader.efi.canTouchEfiVariables = true;
  };

  systemd = {
    settings.Manager.DefaultTimeoutStopSec = lib.mkForce "10s";
    services."user@".serviceConfig.TimeoutStopSec = lib.mkForce "10s";
  };

  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
    desktopManager.xterm.enable = false;
    excludePackages = [ pkgs.xterm ];
  };

  # 4. Individual user configuration (software + informaiton).
  documentation.nixos.enable = false;
  users = {
    defaultUserShell = pkgs.fish;
    users.${variables.username} = {
      description = variables.user_description;
      isNormalUser = true;
      extraGroups = [ "wheel" "plugdev" "storage" "optical" "input" "libvirtd" "lp" "networkmanager" "i2c" "uinput" ];
      shell = pkgs.fish;
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

    hardware.openrgb.enable = true; # OpenRGB

    # For org.freedesktop.portal.Settings (also lazyspotify).
    gnome.gnome-keyring.enable = true;

    # Power profiles. TLP is more advanced but less supported.
    tlp.enable = false;
    power-profiles-daemon.enable = true;
  };

  # For org.freedesktop.portal.Settings (also lazyspotify).
  security.pam.services.login.enableGnomeKeyring = true;

  programs = {
    git.enable = true;
    zsh.enable = true;
    fish.enable = true;
    thunar = {
      enable = true;
      plugins = [ pkgs.thunar-volman ];
    };
    # For GVFS
    dconf.enable = true;
    xfconf.enable = true;

    gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    # permittedInsecurePackages = [
    #   "electron-39.8.10"
    # ];
  };

  environment = {
    variables = {
      NIXPKGS_ALLOW_UNFREE = "1";
      __VERSION = config.system.nixos.version;
      __STATE = config.system.stateVersion;
      SHARED_PATH = variables.shared;
      SHARED_MEDIA_PATH = variables.media; # Wallpapers.
      L_PATH = variables.lshared;

      __EGL_VENDOR_LIBRARY_DIRS = "/run/opengl-driver/share/glvnd/egl_vendor.d";

      WLR_NO_HARDWARE_CURSORS = "1"; # If your cursor becomes invisible.
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINTS = "auto";
      NVD_BACKEND = "direct";

      JAVA_HOME = "${pkgs.temurin-bin-21}";

      # GTK_THEME = variables.theme_gtk;

      EDITOR = "nvim";
      TERMINAL = "kitty";
    };

    systemPackages = with pkgs; [
      # Main tools.
      nurl # Fetch hash from git repos.
      curl wget git
      openssh
      font-manager libnotify killall ffmpegthumbnailer
      fastfetch countryfetch btop neovim micro mousepad
      mpv file
      duf # Mini alternative for disks usage.
      pavucontrol pulseaudio
      bat eza fzf ripgrep fd # fd - find, ripgrep [rg] - grep.
      # superfile
      (yazi.override {
        _7zz = _7zz-rar;  # Support for RAR extraction
      })
      gum # Useful for shell scripts.
      grub2 # grub-reboot INDEX.
    ];
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      applefonts.sf-pro
      applefonts.sf-pro-nerd
      applefonts.sf-mono-nerd
    ];
  };
}
# configuration.nix - used tonybtw.com/tutorial/nixos-from-scratch
# Definitions: lambda - function without a name (literally any.nix file)
{ config, lib, pkgs, inputs, ... }:

let
  variables = import ./variables.nix;
  applefonts = inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system};
in {
  # 1. Import files.
  imports = [
      # 1.1. Base configuration.
      ./hardware-configuration.nix
      ./hardware
      ./hardware/mouse.nix
      # ./hardware/airpods.nix

      # 1.2. GPU/iGPU.
      ./hardware/nvidia
      # ./hardware/vmware.nix
      # Choose or adjust GPU configuration (custom folder)
    
      # 1.3. Updating schedule.
      ./system/updates.nix

      # 1.4. System files.
      # ./system/boot-theme.nix
      # ./system/grub-theme.nix
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

      ./pkgs/github.nix
      ./system/packages/imagemagick-mimes.nix
    ];
    
  
  # 2. Experimental features and session variables.
  _module.args.variables = variables; # Add variable to NixOS modules (system-wide).
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # 3. System configuration (hardware).
  system.stateVersion = variables.version;
  networking.hostName = variables.host;
  boot = {
    kernelPackages = pkgs."linuxPackages_${variables.kernel}";
    supportedFilesystems = [ "ntfs" "ntfs3g" ];
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
  };

  # 4. Individual user configuration (software + informaiton).
  documentation.nixos.enable = false;
  users = {
    defaultUserShell = pkgs.zsh;
    users.${variables.username} = {
      description = "User account created by MolniOS configuration.";
      isNormalUser = true;
      extraGroups = [ "wheel" "plugdev" "storage" "optical" "input" "libvirtd" ];
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

    hardware.openrgb.enable = true; # OpenRGB

    # For org.freedesktop.portal.Settings (also lazyspotify).
    gnome.gnome-keyring.enable = true;
  };

  # For org.freedesktop.portal.Settings (also lazyspotify).
  security.pam.services.login.enableGnomeKeyring = true;

  programs = {
    git.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    zsh.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-volman
        thunar-archive-plugin
      ];
    };
    # For GVFS
    dconf.enable = true;
    xfconf.enable = true;

    gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
  };

  nixpkgs.config.allowUnfree = true;

  environment = {
    variables = {
      NIXPKGS_ALLOW_UNFREE = "1";
      __VERSION = config.system.nixos.version;
      __STATE = config.system.stateVersion;
      SHARED_PATH = variables.shared;
      SHARED_MEDIA_PATH = variables.media; # Wallpapers.
      L_PATH = variables.lshared;

      __EGL_VENDOR_LIBRARY_DIRS = "/run/opengl-driver/share/glvnd/egl_vendor.d";

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
      nurl # Fetch hash from git repos.
      curl wget git
      openssh ntfs3g
      font-manager libnotify killall ffmpegthumbnailer
      fastfetch countryfetch btop neovim micro
      mpv file
      superfile
      pavucontrol pulseaudio
      bat eza yazi fzf ripgrep fd # fd - find, ripgrep [rg] - grep.
      # CLI tools - useful for multiple accounts.
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    applefonts.sf-pro
    applefonts.sf-pro-nerd
    applefonts.sf-mono-nerd
  ];
}
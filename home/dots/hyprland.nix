# User-wide hyprland module.
{ pkgs, config, variables, ... }: {
  # Enabling Hyprland.
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # Might break hyprland autolaunch.
    xwayland.enable = true;
  };

  # Packages.
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  home.packages = with pkgs; [
    hyprmod
    hyprmoncfg
    hyprglass
    hypr3d # Loaded by the shared Lua config from the Home Manager profile.
    # Config autocompletion - lua-language-server
  ];

  # Files.
  xdg.configFile = {
    "hypr/hyprland.lua" = {
      source = config.lib.file.mkOutOfStoreSymlink variables.hyprland;
      force = true;
    };
  };
}

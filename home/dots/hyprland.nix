# User-wide hyprland module.
{ pkgs, variables, ... }: {
  # Enabling Hyprland.
  wayland.windowManager.hyprland = {
    enable = true;
    # Keeps graphical-session.target active, as required by the capture portal.
    systemd.enable = true;
    configType = "lua";
    # Let Home Manager generate session hooks while loading the live shared config.
    extraConfig = ''
      dofile(${builtins.toJSON variables.hyprland})
    '';
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
}

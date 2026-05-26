{ pkgs, ... }: {
  boot.loader.grub = {
    minegrub-theme = {
      enable = true;
      splash = "Welcome to MolniOS!";
      background = "background_options/1.8  - [Classic Minecraft].png";
      # https://github.com/Lxtharia/minegrub-theme/tree/dev/background_options:
      # "background_options/1.8  - [Classic Minecraft].png"
      # Or supply an absolute path to your own 1920x1080 PNG.

      # Number of boot entries in your menu. Adjusts the layout so the
      # "Options" / "Console" bar doesn't overlap the boot buttons.
      # Run "grep -E "menuentry " /boot/grub/grub.cfg | wc -l"
      # to count yours if unsure.
      boot-options-count = 4;
    };

    # Recommended: show the menu immediately instead of requiring ESC.
    # (If this is already set in configuration.nix, remove it here.)
    # splashMode = "normal";   # uncomment if needed
  };
}

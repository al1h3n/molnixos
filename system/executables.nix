# executables.nix - running non-Nix binaries.
# Run games which use SDL with: DISPLAY=:0 SDL_VIDEODRIVER=x11 ./GAME
#
# Two separate mechanisms, do not confuse them:
#   nix-ld       - lets a *dynamically linked* foreign ELF find its libraries.
#   programs.appimage - lets an *AppImage* run at all. AppImages ship their own
#                  libraries and need FUSE plus a runtime, which nix-ld does not
#                  provide. Without this, `./thing.AppImage` just fails.
{ pkgs, ... }: {
  programs = {
    appimage = {
      enable = true;
      binfmt = true; # run ./thing.AppImage directly, no appimage-run wrapper
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib # libstdc++, needed by nearly everything

        # OpenGL / GPU
        libGL

        # SDL2 display + input
        SDL2
        SDL2_mixer
        SDL2_image

        # X11 (for XWayland - SDL defaults to X11)
        libX11
        libXext
        libXrandr
        libXi
        libXcursor
        libXfixes

        # Wayland
        wayland
        libxkbcommon

        # Audio. libpulseaudio is the client library; the `pulseaudio` server
        # package does not ship one, and `pipewire` only matters via libpulse.
        alsa-lib
        libpulseaudio

        zlib
      ];
    };
  };
}

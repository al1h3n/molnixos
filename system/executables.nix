# executables.nix - fix for standalone UNIX files.
# Run games which use SDL with: DISPLAY=:0 SDL_VIDEODRIVER=x11 ./GAME
{ pkgs, ... }: {
  programs = {
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        vlc
        stdenv.cc.cc.lib

        # OpenGL / GPU
        libGL
        mesa
        mesa.drivers

        # SDL2 display + input
        SDL2
        SDL2_mixer
        SDL2_image

        # X11 (for XWayland - FNF uses SDL which defaults to X11)
        xorg.libX11
        xorg.libXext
        xorg.libXrandr
        xorg.libXi
        xorg.libXcursor
        xorg.libXfixes

        # Wayland
        wayland
        libxkbcommon

        # Audio
        alsa-lib
        pulseaudio
        pipewire

        # Other common deps
        zlib
        glibc
      ];
    };
  };
}
{ pkgs, lib, src }:

pkgs.stdenv.mkDerivation {
  pname = "sxwm";
  version = "unstable";

  inherit src;

  buildInputs = with pkgs; [
    xorg.libX11
    xorg.libXinerama
    xorg.libXcursor
  ];

  nativeBuildInputs = with pkgs; [ gnumake ];

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = {
    description = "A simple feature-rich dynamic tiling window manager";
    license     = lib.licenses.gpl3Only;
    platforms   = lib.platforms.linux;
    mainProgram = "sxwm";
  };
}
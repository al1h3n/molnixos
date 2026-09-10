{ stdenv, lib, src, xorg }:
stdenv.mkDerivation {
  pname = "sxwm";
  version = "unstable";
  inherit src;

  buildInputs = [
    xorg.libX11
    xorg.libXinerama
    xorg.libXcursor
  ];

  # gnumake was dropped from nativeBuildInputs: stdenv already provides GNU make.

  installPhase = ''
    runHook preInstall
    make install PREFIX=$out
    runHook postInstall
  '';

  meta = {
    description = "A simple feature-rich dynamic tiling window manager";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "sxwm";
  };
}
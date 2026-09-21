{ stdenv, lib, cmake, ninja, pkg-config, libpulseaudio, openssl, qt6, src }:
stdenv.mkDerivation {
  pname = "librepods-noctalia";
  version = "unstable";
  inherit src;

  strictDeps = true;
  cmakeFlags = [ "-DBUILD_TESTING=OFF" ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    libpulseaudio
    openssl
    qt6.qtbase
    qt6.qtconnectivity
    qt6.qtdeclarative
    qt6.qttools
  ];

  meta = {
    description = "Patched librepods daemon required by Noctalia's AirPods plugin";
    homepage = "https://github.com/harveywuk/librepods";
    license = lib.licenses.gpl3Only;
    mainProgram = "librepods";
    platforms = lib.platforms.linux;
  };
}

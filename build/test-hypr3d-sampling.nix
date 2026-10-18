{ stdenv, pkg-config, hyprgraphics, hyprutils, cairo, libglvnd, src }:
stdenv.mkDerivation {
  pname = "hypr3d-sampling-check";
  version = "1";
  inherit src;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ hyprgraphics hyprutils cairo libglvnd ];
  dontConfigure = true;
  buildPhase = ''
    $CXX -std=c++23 -O2 -pthread -I. -Isrc \
      ${./tests/hypr3d-sampling.cpp} src/Render/MapModel.cpp \
      src/Render/PlayerModel.cpp src/World/MapCollision.cpp src/World/Camera.cpp \
      $(pkg-config --cflags --libs hyprgraphics hyprutils cairo) -lGLESv2 -lEGL \
      -o check-sampling
  '';
  installPhase = ''
    install -Dm755 check-sampling $out/bin/check-sampling
  '';
}

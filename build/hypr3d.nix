# Build against the same Hyprland headers and libraries as the compositor.
{ lib, mkHyprlandPlugin, src, cmake, hyprland }:

mkHyprlandPlugin {
  pluginName = "hypr3d";
  version = "unstable";
  inherit src;

  # Local rendering fixes: optional base textures and authored glTF samplers.
  patches = [
    ./hypr3d-untextured-materials.patch
    ./hypr3d-texture-filtering.patch
  ];

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [
    "-DHYPRLAND_HEADERS=${hyprland.dev}"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 hypr3d.so $out/lib/hypr3d.so

    runHook postInstall
  '';

  meta = {
    description = "A walkable 3D workspace for Hyprland";
    homepage = "https://github.com/samine825/Hypr3D";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}

# HyprGlass - liquid glass effect plugin for Hyprland.
#
# Built from source against the exact pkgs.hyprland in use. A prebuilt .so
# never loads: the plugin embeds the aquamarine/hyprutils/hyprlang/hyprcursor/
# hyprgraphics versions it was built with and refuses to load on a mismatch,
# and nixpkgs pairs Hyprland with different versions than upstream releases do.
{ lib, mkHyprlandPlugin, src }:

mkHyprlandPlugin {
  pluginName = "hyprglass";
  version = "unstable";
  inherit src;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv hyprglass.so $out/lib/libhyprglass.so

    runHook postInstall
  '';

  meta = {
    description = "Liquid glass effect for Hyprland";
    homepage = "https://github.com/hyprnux/hyprglass";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}

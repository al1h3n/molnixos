{ lib, buildGoModule, src }:
buildGoModule {
  pname = "lazyspotify";
  version = "unstable";
  inherit src;
  vendorHash = "sha256-Axdt3/3ZOZY9Z5VUI6Wh77oIREOO26ODMyEgtscTmn8=";
  subPackages = [ "cmd/lazyspotify" ];
  meta = with lib; {
    description = "Terminal Spotify client";
    homepage = "https://github.com/dubeyKartikay/lazyspotify";
    license = licenses.mit;
    mainProgram = "lazyspotify";
  };
}
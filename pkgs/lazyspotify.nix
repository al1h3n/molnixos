{ lib, buildGoModule, src }:
buildGoModule {
  pname = "lazyspotify";
  version = "unstable";
  inherit src;
  vendorHash = lib.fakeHash; # ← changed from "sha256-XXXX"
  subPackages = [ "cmd/lazyspotify" ];
  meta = with lib; {
    description = "Terminal Spotify client";
    homepage = "https://github.com/dubeyKartikay/lazyspotify";
    license = licenses.mit;
    mainProgram = "lazyspotify";
  };
}
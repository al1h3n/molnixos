{ lib, buildGoModule, src }:

buildGoModule {
  pname = "lazyspotify";
  version = "unstable";

  inherit src; # comes from flake input, hash is in flake.lock

  vendorHash = "sha256-XXXX"; # only changes when go.mod/go.sum changes

  subPackages = [ "cmd/lazyspotify" ];

  meta = with lib; {
    description = "Terminal Spotify client";
    homepage = "https://github.com/dubeyKartikay/lazyspotify";
    license = licenses.mit;
    mainProgram = "lazyspotify";
  };
}
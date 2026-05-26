{ rustPlatform, lib, src }:
rustPlatform.buildRustPackage {
  pname = "tuilet";
  version = "unstable";
  inherit src;

  cargoLock.lockFile = "${src}/Cargo.lock";

  meta = {
    description = "A TUI for toilet";
    license = lib.licenses.bsd3;
  };
}
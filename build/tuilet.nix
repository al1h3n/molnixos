{ rustPlatform, lib, src }:
rustPlatform.buildRustPackage {
  pname = "tuilet";
  version = "0.3.0";
  inherit src;

  cargoLock.lockFile = "${src}/Cargo.lock";

  meta = {
    description = "A TUI for toilet";
    license = lib.licenses.bsd3;
  };
}
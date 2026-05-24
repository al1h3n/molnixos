{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gnumake gcc
    python3
    (pipx.overrideAttrs (old: { doCheck = false; })) # pipx temporary fix
    temurin-bin-8 temurin-bin-21 temurin-bin-25
    cargo nodejs-slim_22
  ];
}
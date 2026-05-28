{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gnumake gcc
    python3
    python3Packages.pip # pipx # Removed due to bugs.
    uv # Use instead of pip in projects where you have a lot of dependencies.
    temurin-bin-8 temurin-bin-21 temurin-bin-25
    cargo nodejs-slim_22
  ];
}
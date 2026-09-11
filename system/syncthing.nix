# syncthing.nix - continuous file sync between your devices.
# Web dashboard: http://127.0.0.1:8384
{ variables, ... }: {
  services.syncthing = {
    enable = true;
    user = variables.username;
    group = "users";
    dataDir = "/home/${variables.username}";
    configDir = "/home/${variables.username}/.config/syncthing";
    openDefaultPorts = true;

    # Loopback only. Do not expose this: the GUI is unauthenticated until you
    # set a password in Actions -> Settings -> GUI. Reach it from another
    # machine with `ssh -L 8384:127.0.0.1:8384 MolniPC` instead.
    guiAddress = "127.0.0.1:8384";

    # Both default to true, which makes Nix the only source of truth and
    # deletes any device or folder added through the web UI on the next
    # rebuild. Since you want to pair devices from the dashboard, that has to
    # be off. Declare them under `settings.devices` / `settings.folders` later
    # if you ever want them in the repo, and flip these back.
    overrideDevices = false;
    overrideFolders = false;
  };
}

{ pkgs, ... }: {
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      verbatimConfig = ''
      cgroup_device_acl = [
        "/dev/null", "/dev/full", "/dev/zero",
        "/dev/random", "/dev/urandom",
        "/dev/ptmx", "/dev/kvm",
        "/dev/dri/card0",
        "/dev/dri/card1",
        "/dev/dri/renderD128",
        "/dev/dri/renderD129"
      ]
      nvram = []
      '';
    };
  };
}

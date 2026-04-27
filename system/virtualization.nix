# Uses libvirtd as backend.
{ pkgs, lib, ... }: {
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
        "/dev/dri/renderD129",

        "/dev/nvidia0",
        "/dev/nvidiactl",
        "/dev/nvidia-modeset",
        "/dev/nvidia-uvm",
        "/dev/nvidia-uvm-tools"
      ]

      nvram = []
    '';
    };
  };
  systemd.services = {
    libvirtd.serviceConfig = {
      TimeoutStopSec = lib.mkOverride 0 "10s";
      ExecStopPost = [ "${pkgs.libvirt}/bin/virsh net-destroy default || true" ];
      LoadCredentialEncrypted = lib.mkForce [];
    };
    "libvirt-guests".serviceConfig.TimeoutStopSec = lib.mkForce "10s";
    libvirtd-network-default = {
      description = "libvirt default network autostart - MolniOS";
      after = [ "libvirtd.service" ];
      requires = [ "libvirtd.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        ${pkgs.libvirt}/bin/virsh net-autostart default
        ${pkgs.libvirt}/bin/virsh net-start default || true
      '';
    };
  };
}
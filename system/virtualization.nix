# libvirtd is lazy here: the daemon is NOT started at boot, only its sockets
# are. The first client to touch /var/run/libvirt/libvirt-sock (virt-manager,
# virsh, virt-viewer) triggers socket activation and systemd starts the daemon
# then. Nothing runs while you are not using VMs, and boot/shutdown no longer
# wait on it.
{ pkgs, lib, ... }: {
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      verbatimConfig = ''
      cgroup_device_acl = [
        "/dev/null", "/dev/full", "/dev/zero",
        "/dev/random", "/dev/urandom",
        "/dev/ptmx", "/dev/kvm",

        "/dev/dri/card1",
        "/dev/dri/renderD128",

        "/dev/nvidia0",
        "/dev/nvidiactl",
        "/dev/nvidia-modeset",
        "/dev/nvidia-uvm",
        "/dev/nvidia-uvm-tools"
      ]
    '';
    };
  };

  systemd.services = {
    # The two units the NixOS module pulls into multi-user.target. Dropping
    # them is what turns "always running" into "on demand"; libvirtd.socket
    # stays in sockets.target and does the activation.
    libvirtd.wantedBy = lib.mkForce [ ];
    libvirt-guests.wantedBy = lib.mkForce [ ];
    libvirtd.serviceConfig = {
      TimeoutStopSec = lib.mkOverride 0 "10s";
      ExecStopPost = [ "-${pkgs.libvirt}/bin/virsh net-destroy default" ];
      LoadCredentialEncrypted = lib.mkForce [ ];
    };
    libvirtd-network-default = {
      description = "libvirt default network autostart - MolniOS";
      after = [ "libvirtd.service" ];
      wantedBy = [ "libvirtd.service" ];
      serviceConfig.Type = "oneshot";
      script = ''
        ${pkgs.libvirt}/bin/virsh net-autostart default || true
        ${pkgs.libvirt}/bin/virsh net-start default || true
      '';
    };
  };
}

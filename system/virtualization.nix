# Uses virt-manager (with libvirtd) for VMs creation.
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ virt-manager virt-viewer ];
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      verbatimConfig = ''
        cgroup_device_acl = [
          "/dev/null", "/dev/full", "/dev/zero",
          "/dev/random", "/dev/urandom",
          "/dev/ptmx", "/dev/kvm",
          "/dev/dri/card0", "/dev/dri/card1",
          "/dev/dri/renderD128", "/dev/dri/renderD129",
          "/dev/nvidia0", "/dev/nvidiactl",
          "/dev/nvidia-modeset",
          "/dev/nvidia-uvm", "/dev/nvidia-uvm-tools"
        ]
        nvram = []
      '';
    };
  };

  systemd.sockets = {
    virtqemud.enable = true;
    virtnetworkd.enable = true;
    virtlogd.enable = true;
  };

  systemd.services.libvirtd-network-default = {
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
}
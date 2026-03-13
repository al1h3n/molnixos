# wiki.nixos.org/wiki/VMware
{ pkgs, ... }: {
  services.xserver.videoDrivers = [ "vmware" ];
  
  virtualisation.vmware.guest = {
    enable = true;
    headless = false;
  };

  # Shared folders are mounted via vmhgfs-fuse (part of open-vm-tools).
  # To mount a shared folder named "myshare" defined in VMware VM settings:
  #   fileSystems."/mnt/hgfs/myshare" = {
  #     device = ".host:/myshare";
  #     fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
  #     options = [ "allow_other" "uid=1000" "gid=100" "auto_unmount" "defaults" ];
  #   };
}
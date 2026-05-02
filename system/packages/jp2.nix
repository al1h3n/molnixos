# JP2 image support.
{ pkgs, ... }: {
  environment = {
    systemPackages = with pkgs; [ openjpeg ];
  };
  services.xserver.gdk-pixbuf.modulePackages = [ pkgs.openjpeg ];
}
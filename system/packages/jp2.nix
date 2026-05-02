# JP2 image support.
{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    imagemagick   # handles JP2 via openjpeg internally
    libheif       # HEIC/HEIF
    libjxl        # JXL
    openjpeg      # JP2 codec (for apps that link it directly, e.g. gThumb)
  ];

  # Only add packages here that actually ship GdkPixbuf loaders.
  # openjpeg does NOT — removing it fixes the build error.
  programs.gdk-pixbuf.modulePackages = with pkgs; [
    librsvg       # SVG loader (ships a real .so loader)
  ];
}
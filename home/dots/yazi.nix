# home.nix (Home Manager)
{ config, lib, variables, ... }: {
  # Ensure yazi's opener uses an ImageMagick-backed viewer for image/* types.
  # This opens all image/* in gThumb; falls back to feh for lighter usage.
  xdg.mimeApps = {
    enable = true;
    defaultApplications = let
      # Generate the set from the same MIME_MAP used above — or just use a wildcard approach.
      imageMimes = [
        "image/jp2" "image/jpx" "image/jpm" "image/jxl"
        "image/avif" "image/heic" "image/heif"
        "image/x-exr" "image/vnd.radiance"
        "image/vnd.adobe.photoshop" "image/x-xcf"
        "image/x-tga" "image/x-pcx" "image/vnd-ms.dds"
        "image/x-canon-cr2" "image/x-canon-cr3"
        "image/x-nikon-nef" "image/x-sony-arw"
        "image/x-adobe-dng" "image/x-fuji-raf"
        "image/x-olympus-orf" "image/x-panasonic-rw2"
        "image/x-hasselblad-3fr" "image/x-sigma-x3f"
      ];
    in
      builtins.listToAttrs (map (m: {
        name = m;
        value = "geeqie.desktop";
      }) imageMimes);
  };
  # Configfile in home-manager doesn't support joining files in 1 argument.
  xdg.configFile."yazi/yazi.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${variables.yazi}/yazi.toml";
    force = true;
  };
  xdg.configFile."yazi/keymap.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${variables.yazi}/keymap.toml";
    force = true;
  };
  xdg.configFile."yazi/theme.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${variables.yazi}/theme.toml";
    force = true;
  };
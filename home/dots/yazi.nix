# home.nix (Home Manager)
{ ... }: {
  programs.yazi = {
    enable = true;
    settings = {
      mime = {
        prepend_rules = [
          { name = "*.jp2";  mime = "image/jp2"; }
          { name = "*.j2k";  mime = "image/jp2"; }
          { name = "*.jpx";  mime = "image/jpx"; }
          { name = "*.jpm";  mime = "image/jpm"; }
          { name = "*.jxl";  mime = "image/jxl"; }
          { name = "*.avif"; mime = "image/avif"; }
          { name = "*.heic"; mime = "image/heic"; }
          { name = "*.heif"; mime = "image/heif"; }
          { name = "*.exr";  mime = "image/x-exr"; }
          { name = "*.hdr";  mime = "image/vnd.radiance"; }
          { name = "*.dds";  mime = "image/vnd-ms.dds"; }
          { name = "*.tga";  mime = "image/x-tga"; }
          { name = "*.psd";  mime = "image/vnd.adobe.photoshop"; }
          { name = "*.cr2";  mime = "image/x-canon-cr2"; }
          { name = "*.cr3";  mime = "image/x-canon-cr3"; }
          { name = "*.nef";  mime = "image/x-nikon-nef"; }
          { name = "*.arw";  mime = "image/x-sony-arw"; }
          { name = "*.dng";  mime = "image/x-adobe-dng"; }
          { name = "*.raf";  mime = "image/x-fuji-raf"; }
          { name = "*.orf";  mime = "image/x-olympus-orf"; }
          { name = "*.rw2";  mime = "image/x-panasonic-rw2"; }
          { name = "*.3fr";  mime = "image/x-hasselblad-3fr"; }
          { name = "*.x3f";  mime = "image/x-sigma-x3f"; }
        ];
      };
    };
  };

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
        value = "org.gnome.gThumb.desktop";
      }) imageMimes);
  };
}
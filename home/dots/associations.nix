{ pkgs, lib, ... }: {
  home.packages = with pkgs; [ # For file previews.
    (yazi.override {
      _7zz = _7zz-rar;  # Support for RAR extraction
    })
    ffmpeg-full # Video
    p7zip # Archives
    jq # .json (not .jsonc)
    poppler-utils # PDF
    fd # File search
    ripgrep # File content search
    fzf # Navigation, zoxide too
    resvg # .svg
    exiftool # Metadata.
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Images & photos.
      #
      # "image/*" = [ "geeqie.desktop" ] was two bugs at once:
      #   1. mimeapps.list has no glob syntax. GIO - and so Thunar - reads the
      #      key literally, finds no MIME type called "image/*", and ignores the
      #      line. Nothing was ever set as the default for image/jpeg.
      #   2. geeqie.desktop does not exist; the file is org.geeqie.Geeqie.desktop.
      #
      # With no default, GIO falls back to whoever claims the type in
      # mimeinfo.cache - and eight apps claim image/jpeg here (feh, gimp,
      # krita x2, nsxiv, geeqie, zathura, satty). Whichever the cache happens to
      # list first wins, and that order changes whenever a package does. That is
      # the "sometimes feh opens, sometimes it doesn't".
      #
      # Explicit types only. feh for what feh decodes, geeqie for the RAW and
      # HDR formats it does not.
    } // lib.genAttrs [
      "image/bmp"
      "image/gif"
      "image/jpeg"
      "image/png"
      "image/svg+xml"
      "image/tiff"
      "image/webp"
      "image/x-bmp"
      "image/x-png"
      "image/x-portable-anymap"
      "image/x-portable-bitmap"
      "image/x-portable-graymap"
      "image/x-portable-pixmap"
      "image/x-tga"
      "image/x-xbitmap"
    ] (_: [ "feh.desktop" ]) // lib.genAttrs [
      "image/avif"
      "image/heic"
      "image/heif"
      "image/jp2"
      "image/jxl"
      "image/vnd.adobe.photoshop"
      "image/vnd.radiance"
      "image/x-adobe-dng"
      "image/x-canon-cr2"
      "image/x-canon-cr3"
      "image/x-exr"
      "image/x-fuji-raf"
      "image/x-nikon-nef"
      "image/x-olympus-orf"
      "image/x-sony-arw"
    ] (_: [ "org.geeqie.Geeqie.desktop" ]) // {

      # Standard Archives.
      "application/zip" = [ "peazip-extract.desktop" ];
      "application/x-7z-compressed" = [ "peazip-extract.desktop" ];
      "application/x-rar" = [ "peazip-extract.desktop" ];
      "application/x-rar-compressed" = [ "peazip-extract.desktop" ];

      # Tarballs. (Plain and Compressed)
      "application/x-tar" = [ "peazip-extract.desktop" ];
      "application/x-compressed-tar" = [ "peazip-extract.desktop" ];
      "application/x-gzip" = [ "peazip-extract.desktop" ];
      "application/x-bzip" = [ "peazip-extract.desktop" ];
      "application/x-bzip2" = [ "peazip-extract.desktop" ];
      "application/x-xz" = [ "peazip-extract.desktop" ];
      "application/x-xz-compressed-tar" = [ "peazip-extract.desktop" ];
      "application/x-lzma" = [ "peazip-extract.desktop" ];
      "application/x-lzip" = [ "peazip-extract.desktop" ];
      
      # Modern & Legacy Formats.
      "application/zstd" = [ "peazip-extract.desktop" ];
      "application/x-zstd-compressed-tar" = [ "peazip-extract.desktop" ];
      "application/x-cpio" = [ "peazip-extract.desktop" ];
      "application/x-arj" = [ "peazip-extract.desktop" ];
      "application/x-xar" = [ "peazip-extract.desktop" ];
      "application/vnd.ms-cab-compressed" = [ "peazip-extract.desktop" ];

      # Gaming formats.
      "application/x-modrinth-modpack+zip" = [ "prismlauncher.desktop" ];

      # Text/coding files.
      "text/plain" = [ "nvim.desktop" ];
      "text/markdown" = [ "codium.desktop" ];
      "application/x-shellscript" = [ "codium.desktop" ];
      "text/x-python" = [ "codium.desktop" ];
      "text/x-csrc" = [ "codium.desktop" ];
      "text/x-chdr" = [ "codium.desktop" ];
      "text/x-c++src" = [ "codium.desktop" ];
      "text/x-c++hdr" = [ "codium.desktop" ];
      "text/javascript" = [ "codium.desktop" ];
      "application/json" = [ "codium.desktop" ];
      "text/css" = [ "codium.desktop" ];
      "text/html" = [ "codium.desktop" ];
      "inode/x-empty" = [ "codium.desktop" ]; # Empty files.
      "inode/empty" = [ "codium.desktop" ];

      # Documents.
      "applications/pdf" = [ "firefox.desktop" ];
    };
  };
}
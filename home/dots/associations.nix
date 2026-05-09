{ pkgs, ... }: {
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
      "image/*" = [ "geeqie.desktop" ];

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
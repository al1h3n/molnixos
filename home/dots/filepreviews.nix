{ pkgs, ... }: {
  home.packages = with pkgs; [
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
  ];
}
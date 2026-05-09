# home/dots/superfile.nix
{ pkgs, ... }: {
  home.packages = with pkgs; [
    chafa          # Image/SVG rendering in terminal (kitty protocol aware)
    atool          # Universal archive lister (zip, tar, 7z, rar, etc.)
    p7zip          # Backend for 7z/zip
    unzip          # ZIP extraction/listing
    hexyl          # Pretty hex viewer for binaries
    poppler-utils  # pdftotext — PDF preview
  ];
}
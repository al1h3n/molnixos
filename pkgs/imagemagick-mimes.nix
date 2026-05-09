# images.nix
{ config, pkgs, lib, ... }:

let
  imagemagickMimes = pkgs.runCommand "imagemagick-mime-types"
    { nativeBuildInputs = [ pkgs.imagemagick pkgs.python3 ]; }
    ''
      mkdir -p $out/share/mime/packages

      python3 - <<'PYEOF' > $out/share/mime/packages/imagemagick-extra.xml
import subprocess, re

MIME_MAP = {
  "jp2":"image/jp2","j2k":"image/jp2","jpx":"image/jpx",
  "jpm":"image/jpm","j2c":"image/jp2","jpc":"image/jp2",
  "jpg2":"image/jp2","jpf":"image/jpx",
  "png":"image/png","gif":"image/gif",
  "jpg":"image/jpeg","jpeg":"image/jpeg",
  "webp":"image/webp","avif":"image/avif",
  "heic":"image/heic","heif":"image/heif",
  "tiff":"image/tiff","tif":"image/tiff",
  "bmp":"image/bmp","ico":"image/x-icon",
  "svg":"image/svg+xml","svgz":"image/svg+xml",
  "exr":"image/x-exr","hdr":"image/vnd.radiance",
  "pfm":"image/x-portable-floatmap",
  "psd":"image/vnd.adobe.photoshop","xcf":"image/x-xcf",
  "pnm":"image/x-portable-anymap","pbm":"image/x-portable-bitmap",
  "pgm":"image/x-portable-graymap","ppm":"image/x-portable-pixmap",
  "pam":"image/x-portable-arbitrarymap",
  "pcx":"image/x-pcx","tga":"image/x-tga",
  "xbm":"image/x-xbitmap","xpm":"image/x-xpixmap",
  "dds":"image/vnd-ms.dds","wdp":"image/vnd.ms-photo",
  "jxr":"image/vnd.ms-photo","jxl":"image/jxl",
  "cr2":"image/x-canon-cr2","cr3":"image/x-canon-cr3",
  "crw":"image/x-canon-crw","nef":"image/x-nikon-nef",
  "nrw":"image/x-nikon-nef","arw":"image/x-sony-arw",
  "srf":"image/x-sony-srf","sr2":"image/x-sony-sr2",
  "dng":"image/x-adobe-dng","raf":"image/x-fuji-raf",
  "orf":"image/x-olympus-orf","rw2":"image/x-panasonic-rw2",
  "pef":"image/x-pentax-pef","k25":"image/x-kodak-k25",
  "kdc":"image/x-kodak-kdc","dcr":"image/x-kodak-dcr",
  "mrw":"image/x-minolta-mrw","erf":"image/x-epson-erf",
  "3fr":"image/x-hasselblad-3fr","fff":"image/x-hasselblad-fff",
  "iiq":"image/x-phaseone-iiq","rwl":"image/x-leica-rwl",
  "srw":"image/x-samsung-srw","x3f":"image/x-sigma-x3f",
  "eps":"image/x-eps","ps":"application/postscript",
  "mng":"video/x-mng","jng":"image/x-jng",
  "cur":"image/vnd.microsoft.icon",
}

SKIP = {
  "pdf","ps","eps","txt","htm","html","json","xml","null","label",
  "win","screenshot","clipboard","xwd","yuv","gray","mono","rgb",
  "rgba","cmyk","cmyka","bgr","bgra","uyvy","gradient","radial-gradient",
  "plasma","tile","pattern","rose","logo","netscape","wizard",
  "fractal","magick","xc","canvas","caption","pango","mvg",
  "djvu","djv","avi","mov","mp4","mkv","mpg","mpeg",
}

result = subprocess.run(
    ["magick", "-list", "format"],
    capture_output=True, text=True
)

extensions = set()
for line in result.stdout.splitlines():
    m = re.match(r"^\s+([A-Z0-9]+)\*?\s+\S", line)
    if m:
        ext = m.group(1).lower()
        if ext not in SKIP and len(ext) <= 6:
            extensions.add(ext)

mime_to_exts: dict[str, list[str]] = {}
for ext in sorted(extensions):
    mime = MIME_MAP.get(ext, f"image/x-{ext}")
    mime_to_exts.setdefault(mime, []).append(ext)

lines = [
    '<?xml version="1.0" encoding="UTF-8"?>',
    '<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">',
]
for mime, exts in sorted(mime_to_exts.items()):
    lines.append(f'  <mime-type type="{mime}">')
    for ext in sorted(exts):
        lines.append(f'    <glob pattern="*.{ext}"/>')
        lines.append(f'    <glob pattern="*.{ext.upper()}"/>')
    lines.append("  </mime-type>")
lines.append("</mime-info>")
print("\n".join(lines))
PYEOF
    '';

  imageMimeApps = pkgs.runCommand "imagemagick-mimeapps"
    { nativeBuildInputs = [ pkgs.imagemagick pkgs.python3 ]; }
    ''
      mkdir -p $out/etc/xdg

      python3 - <<'PYEOF' > $out/etc/xdg/imagemagick-mimeapps.list
import subprocess, re

MIME_MAP = {
  "jp2":"image/jp2","j2k":"image/jp2","jpx":"image/jpx",
  "jpm":"image/jpm","j2c":"image/jp2",
  "png":"image/png","gif":"image/gif",
  "jpg":"image/jpeg","jpeg":"image/jpeg",
  "webp":"image/webp","avif":"image/avif",
  "heic":"image/heic","heif":"image/heif",
  "tiff":"image/tiff","tif":"image/tiff",
  "bmp":"image/bmp","ico":"image/x-icon",
  "exr":"image/x-exr","hdr":"image/vnd.radiance",
  "psd":"image/vnd.adobe.photoshop","xcf":"image/x-xcf",
  "pnm":"image/x-portable-anymap","pbm":"image/x-portable-bitmap",
  "pgm":"image/x-portable-graymap","ppm":"image/x-portable-pixmap",
  "pcx":"image/x-pcx","tga":"image/x-tga",
  "jxl":"image/jxl","dds":"image/vnd-ms.dds",
  "cr2":"image/x-canon-cr2","nef":"image/x-nikon-nef",
  "arw":"image/x-sony-arw","dng":"image/x-adobe-dng",
  "raf":"image/x-fuji-raf","orf":"image/x-olympus-orf",
  "rw2":"image/x-panasonic-rw2",
}

SKIP = {
  "pdf","ps","eps","txt","html","xml","null","label","win",
  "gradient","plasma","rose","logo","netscape","wizard","fractal",
  "magick","xc","canvas","caption","pango","mvg",
  "avi","mov","mp4","mkv","mpg","mpeg",
}

result = subprocess.run(["magick", "-list", "format"], capture_output=True, text=True)
mimes = set()
for line in result.stdout.splitlines():
    m = re.match(r"^\s+([A-Z0-9]+)\*?\s+\S", line)
    if m:
        ext = m.group(1).lower()
        if ext not in SKIP and len(ext) <= 6:
            mimes.add(MIME_MAP.get(ext, f"image/x-{ext}"))

print("[Added Associations]")
for mime in sorted(mimes):
    print(f"{mime}=org.gnome.gThumb.desktop;feh.desktop;eog.desktop;")
PYEOF
    '';
in
{
  environment.systemPackages = with pkgs; [
    imagemagick
    gthumb
    feh
    imagemagickMimes
    librsvg
  ];

  environment.pathsToLink = [ "/share/mime" "/share/applications" ];

  xdg.mime.enable = true;

  environment.etc."xdg/mimeapps.list".source =
    "${imageMimeApps}/etc/xdg/imagemagick-mimeapps.list";

  system.activationScripts.updateMimeDb = lib.stringAfter [ "specialfs" ] ''
    if [ -d /run/current-system/sw/share/mime ]; then
      ${pkgs.shared-mime-info}/bin/update-mime-database \
        -V /run/current-system/sw/share/mime 2>/dev/null || true
    fi
  '';
}
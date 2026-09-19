{
  config,
  lib,
  pkgs,
  ...
}:

let
  themeName = "Bibata-Modern-Custom";

  # The greeter cannot use files generated inside the user's home directory,
  # so keep one declarative fallback in the system closure. The logged-in
  # session is recolored live by ./home.nix instead.
  fallback = {
    accent = "#9687c4";
    outline = "#1c1a23";
  };

  cursorPackage = pkgs.stdenvNoCC.mkDerivation {
    pname = "bibata-modern-custom";
    inherit (pkgs.bibata-cursors) version src;

    nativeBuildInputs = [
      pkgs.clickgen
      pkgs.imagemagick
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      install -dm0755 "bitmaps/${themeName}"
      cp -r ${pkgs.bibata-cursors.bitmaps}/Bibata-Modern-Ice/. "bitmaps/${themeName}/"
      chmod -R u+w "bitmaps/${themeName}"

      magick mogrify \
        -channel RGB \
        +level-colors '${fallback.outline},${fallback.accent}' \
        -type TrueColorAlpha \
        -define png:color-type=6 \
        "bitmaps/${themeName}"/*.png

      ctgen configs/normal/x.build.toml \
        -p x11 \
        -d "bitmaps/${themeName}" \
        -n '${themeName}' \
        -c 'Bibata Modern cursor using the Noctalia palette'

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -dm0755 "$out/share/icons"
      cp -r "themes/${themeName}" "$out/share/icons/"

      runHook postInstall
    '';

    meta = {
      description = "Bibata Modern cursor colored from the Noctalia palette";
      homepage = "https://github.com/ful1e5/Bibata_Cursor";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.linux;
    };
  };
in
{
  options.lysec.cursor = {
    theme = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "Custom Bibata cursor theme name.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      description = "Declarative fallback cursor package used by the greeter.";
    };
  };

  config.lysec.cursor = {
    theme = themeName;
    package = cursorPackage;
  };
}

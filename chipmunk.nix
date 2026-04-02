{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, zlib
, openssl
, xorg
, gtk3
, glib
, nss
, nspr
, mesa
, alsa-lib
, ...
}:

stdenv.mkDerivation rec {
  pname = "chipmunk";
  version = "3.19.4";

  src = fetchurl {
    url = "https://github.com/esrlabs/chipmunk/releases/download/${version}/chipmunk@${version}-linux-x86_64.deb";
    sha256 = "sha256-KKwRE7PWEMmhgOdqP647Ez8sc9yIp+vuFkPFjABeEWM=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    zlib
    openssl
    gtk3
    glib
    nss
    nspr
    mesa
    alsa-lib
    xorg.libX11
    xorg.libXext
    xorg.libXrandr
    xorg.libXrender
    xorg.libxcb
  ];

  unpackPhase = ''
    runHook preUnpack

    ${dpkg}/bin/dpkg-deb -x "$src" .

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    if [ -d usr ]; then
      cp -r usr/* $out/
    fi

    mkdir -p $out/share/applications
    cp \
      $out/lib/chipmunk/chipmunk/resources/app.asar.unpacked/resources/linux/chipmunk.desktop \
      $out/share/applications/chipmunk.desktop
    chmod +x $out/share/applications/chipmunk.desktop

    substituteInPlace $out/share/applications/chipmunk.desktop \
      --replace-fail 'Icon=chipmunk.png' 'Icon=chipmunk' \
      --replace-fail 'Exec=chipmunk %f' 'Exec=${placeholder "out"}/bin/chipmunk %f'

    mkdir -p $out/share/icons/hicolor/{16x16,24x24,32x32,64x64,128x128,256x256,512x512}/apps
    for size in 16 24 32 64 128 256 512; do
      cp \
        $out/lib/chipmunk/chipmunk/resources/app.asar.unpacked/resources/icons/png/$size.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/chipmunk.png
    done

    cp \
      $out/lib/chipmunk/chipmunk/resources/app.asar.unpacked/resources/linux/chipmunk.png \
      $out/share/icons/hicolor/512x512/apps/chipmunk.png

    runHook postInstall
  '';
  meta = with lib; {
    description = "chipmunk log analysis tool";
    # platforms = platforms.linux;
    platforms = ["x86_64-linux"];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}


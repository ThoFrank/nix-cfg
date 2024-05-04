{ stdenv
, fetchFromGitHub
, pkg-config
, which
}:

stdenv.mkDerivation rec {
  pname = "camera-streamer";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "ayufan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CmNUomVlDIXUb2C0+bpCh5EYh9upPOL2T0155c9b5AU=";
  };

  buildInputs = [
    pkg-config
    which
  ];

  GIT_VERSION = version;
  GIT_REVISION = "bc23191";

  patchPhase = ''
    # sed -i 's/\[N_FDS\]/\[\(unsigned int\)N_FDS\]/g' device/links.c
    sed -i '/GIT_VERSION/s/echo/printf/g' Makefile
  '';
}

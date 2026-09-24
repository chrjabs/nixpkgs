{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  clp-unstable,
  coin-utils-unstable,
  osi-unstable,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cgl";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "Cgl";
    rev = "c40870f57925887be75881a6528886a720f69984";
    hash = "sha256-F9p8vLPjcBunNhTw0NGy4Ee6pabxLShE2lE2JdrWbJE=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    clp-unstable
    coin-utils-unstable
    osi-unstable
  ];

  meta = {
    description = "Cut Generator Library";
    homepage = "https://github.com/coin-or/Cgl";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.unix;
  };
})

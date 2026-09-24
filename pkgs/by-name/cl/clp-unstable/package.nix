{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  coin-utils-unstable,
  zlib,
  osi-unstable,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "unstable";
  pname = "clp";
  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "Clp";
    rev = "258c63fd04e665c1b6533ce6646711d6e2830e45";
    hash = "sha256-Klkc1AS2UsPCLvMS/nRtR4JoKkWzV3RYXPIMLhOq8LY=";
  };

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [
    zlib
    coin-utils-unstable
    osi-unstable
  ];

  doCheck = true;

  meta = {
    license = lib.licenses.epl20;
    homepage = "https://github.com/coin-or/Clp";
    description = "Open-source linear programming solver written in C++";
    mainProgram = "clp";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    maintainers = [ lib.maintainers.vbgl ];
  };
})

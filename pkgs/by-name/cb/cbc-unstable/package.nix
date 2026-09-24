{
  lib,
  stdenv,
  fetchFromGitHub,
  bzip2,
  cgl-unstable,
  clp-unstable,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cbc";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "Cbc";
    rev = "ebdd664d12304789db1aec1bd512e087a2666549";
    sha256 = "sha256-7Rje/3g5HyaE+y7AzfKS6cvDlMVngyBHIr0bRLzn3II=";
  };

  # or-tools has a hard dependency on Cbc static libraries, so we build both
  configureFlags = [
    "-C"
    "--enable-static"
  ]
  ++ lib.optionals stdenv.cc.isClang [ "CXXFLAGS=-std=c++14" ];

  nativeBuildInputs = [ pkg-config ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  buildInputs = [
    bzip2
    zlib
  ];

  # cbc lists cgl and clp in its .pc requirements, so it needs to be propagated.
  propagatedBuildInputs = [
    cgl-unstable
    clp-unstable
  ];

  # FIXME: move share/coin/Data to a separate output?

  meta = {
    homepage = "https://projects.coin-or.org/Cbc";
    license = lib.licenses.epl10;
    maintainers = [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    description = "Mixed integer programming solver";
  };
})

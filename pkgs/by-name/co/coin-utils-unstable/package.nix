{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  bzip2,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "unstable";
  pname = "coinutils";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "CoinUtils";
    rev = "4054af6f350ed5b432018e283ce6b0dbbb1ca13e";
    hash = "sha256-8T8SGZC6eZ1nUhPTcp5IQfxt9SD8GlKy5idJIcwH6VI=";
  };

  nativeBuildInputs = [
    pkg-config
    bzip2
    zlib
  ];

  doCheck = true;

  meta = {
    license = lib.licenses.epl20;
    homepage = "https://github.com/coin-or/CoinUtils";
    description = "Collection of classes and helper functions that are generally useful to multiple COIN-OR projects";
    maintainers = with lib.maintainers; [ tmarkus ];
  };
})

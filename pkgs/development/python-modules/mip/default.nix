{
  lib,
  stdenv,
  buildPythonPackage,
  cffi,
  dos2unix,
  fetchFromGitHub,
  matplotlib,
  networkx,
  numpy,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  wheel,
  cbc-unstable,
  highspy,
  gurobi,
  gurobipy,
  # Enable support for the commercial Gurobi solver (requires a license)
  gurobiSupport ? false,
  # If Gurobi has already been installed outside of the Nix store, specify its
  # installation directory here
  gurobiHome ? null,
}:

buildPythonPackage (finalAttrs: {
  pname = "mip";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "python-mip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DZZcBthTPYb5pTLf1dfmcozquiOIQpnr+dmydhzCj0o=";
  };

  doCheck = false;

  nativeCheckInputs = [
    matplotlib
    networkx
    numpy
    pytestCheckHook
  ];

  nativeBuildInputs = [
    dos2unix
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    cffi
    highspy
    cbc-unstable
  ]
  ++ lib.optionals gurobiSupport ([ gurobipy ] ++ lib.optional (gurobiHome == null) gurobi);

  # Source files have CRLF terminators, which make patch error out when supplied
  # with diffs made on *nix machines
  prePatch = ''
    find . -type f -exec ${dos2unix}/bin/dos2unix {} \;
  '';

  patches = [
    # Use the nix install of CBC by default, since packaging cbcbox for nix is not easy
    ./cbc-lib.patch
    # Some tests try to be smart and dynamically construct a path to their test
    # inputs. Unfortunately, since the test phase is run after installation,
    # those paths point to the Nix store, which no longer contains the test
    # data. This patch hardcodes the data path to point to the source directory.
    ./test-data-path.patch
  ];

  postPatch = ''
    substituteInPlace mip/cbc.py --replace "<nix-cbc-lib>" "${cbc-unstable}/lib/libCbc.so"
  '';

  # Make MIP use the Gurobi solver, if configured to do so
  makeWrapperArgs = lib.optional gurobiSupport "--set GUROBI_HOME ${
    if gurobiHome == null then gurobi.outPath else gurobiHome
  }";

  # Tests that rely on Gurobi are activated only when Gurobi support is enabled
  disabledTests = lib.optional (!gurobiSupport) "gurobi";

  optional-dependencies = {
    inherit gurobipy numpy;
  };

  meta = {
    homepage = "https://python-mip.com/";
    description = "Collection of Python tools for the modeling and solution of Mixed-Integer Linear programs (MIPs)";
    downloadPage = "https://github.com/coin-or/python-mip/releases";
    changelog = "https://github.com/coin-or/python-mip/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.epl20;
    broken = stdenv.hostPlatform.isAarch64;
    maintainers = with lib.maintainers; [
      nessdoor
      chrjabs
    ];
  };
})

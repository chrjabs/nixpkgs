{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
buildPythonPackage (finalAttrs: {
  pname = "pindakaas";
  version = "0.6.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pindakaashq";
    repo = "pindakaas";
    tag = "pyndakaas-v${finalAttrs.version}";
    hash = "sha256-khDadb0sIemv7Rz9IKRH2OuGLPYlEZmGXOxyjv066Kk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-vXRcONfyrHCjcdfjHjpauoRTgiqcHgkBsNIS6VDPWpo=";
  };

  buildAndTestSubdir = "crates/pyndakaas";

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  pythonImportsCheck = [ "pindakaas" ];

  passthrough.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "pyndakaas-v(.*)"
    ];
  };

  meta = {
    description = "Encode integer and pseudo-Boolean constraints into CNF from Python";
    homepage = "https://github.com/pindakaashq/pindakaas";
    changelog = "https://github.com/pindakaashq/pindakaas/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mpl20;
    maintainers = [
      lib.maintainers.chrjabs
    ];
    platforms = lib.platforms.all;
  };
})

{ stdenv, fetchFromGitHub, pkgs, kernel }:

let modDestDir =
      "$out/lib/modules/${kernel.modDirVersion}" +
      "/kernel/drivers/net/wireless/realtek/rtlwifi";
in stdenv.mkDerivation rec {
  pname = "rtl8188gu-${version}-${kernel.version}";
  version = "TESTING";

  src = builtins.path {name = "test"; path = ./.;};

  buildInputs = [ pkgs.bc ];

  configurePhase = ''
    kernel_version=${kernel.modDirVersion}
    sed -i -e 's|/lib/modules|${kernel.dev}/lib/modules|' Makefile
    export makeFlags="BUILD_KERNEL=$kernel_version"
  '';

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p ${modDestDir}
    xz --stdout 8188gtvu.ko > ${modDestDir}/8188gtvu.ko.xz
  '';

  meta = {
    description = "Realtek rtl8188gu linux driver module";
  };
}

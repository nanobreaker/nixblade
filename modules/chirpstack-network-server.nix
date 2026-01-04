{ stdenvNoCC, fetchurl, autoPatchelfHook, sqlite, lib }:

stdenvNoCC.mkDerivation rec {
  pname = "chirpstack";
  version = "4.15.0";

  src = fetchurl {
    url =
      "https://artifacts.chirpstack.io/downloads/chirpstack/chirpstack_${version}_sqlite_linux_arm64.tar.gz";
    hash = "sha256-WKMIPCIhcIO/woe6SOE+clnvH8nwMt14RPO/vf0a45s=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ sqlite ];

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    tar -xzf $src
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/chirpstack

    # be robust to archive folder names
    bin="$(find . -maxdepth 3 -type f -name chirpstack -print -quit)"
    if [ -z "$bin" ]; then
      echo "ERROR: chirpstack binary not found in archive"
      find . -maxdepth 3 -type f -print
      exit 1
    fi

    install -m755 "$bin" $out/bin/chirpstack

    cfgdir="$(dirname "$bin")/config"
    if [ -d "$cfgdir" ]; then
      cp -r "$cfgdir" $out/share/chirpstack/
    fi

    runHook postInstall
  '';

  meta = {
    description = "ChirpStack v4 (sqlite, linux arm64) prebuilt binary";
    platforms = [ "aarch64-linux" ];
  };
}

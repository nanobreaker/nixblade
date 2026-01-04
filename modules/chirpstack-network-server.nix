{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  pname = "chirpstack-network-server";
  version = "4.15";

  src = pkgs.fetchurl {
    url =
      "https://artifacts.chirpstack.io/downloads/chirpstack/chirpstack_4.15.0_sqlite_linux_arm64.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [ pkgs.autoPatchelfHook ];
  buildInputs = [ pkgs.sqlite ];

  unpackPhase = ''
    tar xzf $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp chirpstack $out/bin/

    mkdir -p $out/share/chirpstack
    cp -r config $out/share/chirpstack/
  '';

  meta = with pkgs.lib; {
    description = "ChirpStack LoRaWAN Network Server";
    homepage = "https://www.chirpstack.io/";
    license = licenses.mit;
    platforms = [ "aarch64-linux" ];
  };

}

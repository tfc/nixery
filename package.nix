{ buildGoModule
, makeWrapper
, nixery-prepare-image
}:

let
  version = "1.0";
in

buildGoModule {
  pname = "nixery";
  inherit version;
  src = ./.;
  doCheck = true;

  vendorHash = "sha256-io9NCeZmjCZPLmII3ajXIsBWbT40XiW8ncXOuUDabbo=";

  ldflags = [ "-s" "-w" "-X" "main.version=${version}" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/server \
      --set WEB_DIR "${./web}" \
      --prefix PATH : ${nixery-prepare-image}/bin
  '';
}

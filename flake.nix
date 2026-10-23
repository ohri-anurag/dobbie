{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };
  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      sky = pkgs.stdenv.mkDerivation rec {
        name = "sky";
        version = "0.27.9";
        src = builtins.fetchurl {
          url = "https://github.com/anzellai/sky/releases/download/v${version}/sky-linux-x64.tar.gz";
          sha256 = "sha256:0dyqqqaj1cs55p6k74pra9if7ria432z56w37784iha6c4ilns2j";
        };

        phases = [ "installPhase" ];

        installPhase = ''
          mkdir -p $out/bin
          tar -xf $src -C $out/bin/
          mv $out/bin/sky-linux-x64 $out/bin/sky
          chmod +x $out/bin/sky
        '';
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          sky
          pkgs.go
          (pkgs.postgresql.withPackages (pp: [ pp.pgvector ]))
        ];
      };
    };
}

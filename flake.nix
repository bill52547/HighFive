{
  description = "SparkOps - Spark basic operators";
  inputs.nixpkgs.url = "nixpkgs/nixos-21.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils }:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system; config.allowUnfree = true;
        };
        pname = "HighFive";
      in
      {
        packages.${pname} = with pkgs;
          stdenv.mkDerivation {
            name = pname;
            nativeBuildInputs = [
              cmake
              hdf5
              boost
            ];
            src = ./.;
          };
        defaultPackage = self.packages.${system}.${pname};
        apps.${pname} = flake-utils.lib.mkApp {
          drv = self.packages.${system}.${pname};
        };
        defaultApp = self.apps.${system}.${pname};
        devShell = (with pkgs; pkgs.mkShell {
          inputsFrom = builtins.attrValues self.packages.${system};
        });
      }));
}


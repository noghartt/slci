{
  description = "A flake with Haskell configuration to my SLCI interpreter";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        haskellPackages = pkgs.haskellPackages;

        projectName = "slic";
      in
      rec {
        packages.${projectName} =
          haskellPackages.callCabal2nix projectName self
            rec { };

        defaultPackage = self.packages.${system}.${projectName};

        devShell = pkgs.mkShell {
          buildInputs = with haskellPackages; [
            haskell-language-server
            ghcid
            cabal-install
          ];

          inputsFrom = builtins.attrValues self.packages.${system};
        };
      }
    );
}

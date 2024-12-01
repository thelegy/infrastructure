{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    nixidy = {
      url = "github:arnarg/nixidy";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixhelm = {
      url = "github:farcaller/nixhelm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      flake-utils,
      nixidy,
      ...
    }:
    (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        nixidyEnvs = nixidy.lib.mkEnvs {
          inherit pkgs;

          charts = inputs.nixhelm.chartsDerivations.${system};
          modules = [ ./modules ];

          envs = {
            prod.modules = [ ./env/prod.nix ];
          };
        };

        devShells.default = pkgs.mkShell {
          packages = [ nixidy.packages.${system}.default ];
        };
      }
    ));
}

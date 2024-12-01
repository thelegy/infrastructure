{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixidy.url = "github:arnarg/nixidy";

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      nixidy,
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

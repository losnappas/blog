{
  description = "Project using flakegarden CLI to add language modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    flakegarden.url = "github:losnappas/flakegarden";
    flakegarden.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.flakegarden.flakeModule
      ];
      systems = import inputs.systems;
      perSystem =
        {
          pkgs,
          config,
          self',
          system,
          lib,
          ...
        }:
        {
          imports = inputs.flakegarden.lib.importDir ./nix/garden;
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          treefmt = {
            inherit (config.flake-root) projectRootFile;
            programs = {
              nixfmt.enable = true;
            };
          };

          make-shells.default = {
            packages = [
              pkgs.nil
              pkgs.quartoMinimal
            ];

            # shellHook = ''
            # '';

            # Run treefmt fast via `$PROJECT_FORMATTER files...`.
            env.PROJECT_FORMATTER = lib.getExe config.formatter;
          };

          # packages.default = self'.packages.myDefaultPackage;
        };

      flake = { };
    };
}

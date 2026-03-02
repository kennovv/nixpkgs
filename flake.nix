{

  description = "Custom Nix packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # Auto-discover all packages in ./pkgs directory
        callPackage = path: pkgs.callPackage path { };

        # Define all custom packages here
        packageNames = [
          "bcompare4"
          # Add new packages here as you create them
          # "another-package"
          # "yet-another-package"
        ];

        # Create package set
        customPackages = builtins.listToAttrs (map (name: {
          name = name;
          value = callPackage (./pkgs/${name}) { };
        }) packageNames);

      in
      {
        # Export each package individually
        packages = customPackages // {
          # Also provide 'all' and 'default' convenience attributes
          all = builtins.attrValues customPackages;
          default = customPackages.bcompare4; # or first package as default
        };

        # Export the overlay (this is what we'll use in NixOS)
        overlays.default = import ./overlay.nix;

        # Also export the packages as a separate overlay
        overlays.packages = final: prev: customPackages;
      }
    );

}

{

  description = "Custom Nix packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      # Define the overlay once, outside of eachDefaultSystem
      overlay = import ./overlay.nix;
    in
    {
      # Export the overlay at the top level
      overlays.default = overlay;

      # Also export per-system packages
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ overlay ];
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
      }
    );

}

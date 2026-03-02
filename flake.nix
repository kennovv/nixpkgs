{

  description = "Custom Nix packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      # Define the overlay once
      overlay = import ./overlay.nix;
    in
    {
      # Export the overlay at the top level for NixOS to use
      overlays.default = overlay;

    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ overlay ];
        };
      in
      {
        # Export packages
        packages = {
          bcompare4 = pkgs.bcompare4;
          # Add more packages here as you create them:
          # another-package = pkgs.another-package;
        };
      }
    );

}

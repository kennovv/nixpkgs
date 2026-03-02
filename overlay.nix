final: prev:
let
  # Import all packages from the pkgs directory
  callPackage = path: final.callPackage path { };

  # Auto-discover all subdirectories in ./pkgs
  packageDirs = builtins.attrNames (builtins.readDir ./pkgs);

  # Create package set
  customPackages = builtins.listToAttrs (map (name: {
    name = name;
    value = callPackage (./pkgs/${name}) { };
  }) packageDirs);

in
  customPackages

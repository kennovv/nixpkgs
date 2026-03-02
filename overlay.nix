final: prev: {
  # Explicitly list each package to make available
  bcompare4 = final.callPackage ./pkgs/bcompare4 { };
  # Add more packages here as you create them:
  # another-package = final.callPackage ./pkgs/another-package { };
}

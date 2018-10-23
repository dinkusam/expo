let
  pin = builtins.fromJSON (builtins.readFile ./nixpkgs.json);

  # DONTMERGE
  #nixpkgs = builtins.fetchTarball {
  #  url = "https://github.com/NixOS/nixpkgs-channels/archive/${pin.rev}.tar.gz";
  #  inherit (pin) sha256;
  #};
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/nicknovitski/nixpkgs/archive/android-sdk-26-licenses.tar.gz";
    sha256 = "0zywvbz202hm7qg2792c3csysia83as4a9sphwnhx7l1y7njxbnd";
  };


in

{ ... } @ args:

  import nixpkgs (args // {
    overlays = [ (import ./nix/all-packages.nix) ];
    config = { allowUnfree = true; android_sdk.accept_license = true; };
  })

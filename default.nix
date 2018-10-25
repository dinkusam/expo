let
  pin = builtins.fromJSON (builtins.readFile ./nixpkgs.json);

  # DONTMERGE
  #nixpkgs = builtins.fetchTarball {
  #  url = "https://github.com/NixOS/nixpkgs-channels/archive/${pin.rev}.tar.gz";
  #  inherit (pin) sha256;
  #};
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/nicknovitski/nixpkgs/archive/android-sdk-26-licenses.tar.gz";
    sha256 = "187p7xvs58ss7hbxmbc7i510r9c6ar8lpk7ddb9bm1bxl3zpcsad";
  };


in

{ ... } @ args:

  import nixpkgs (args // {
    overlays = [ (import ./nix/all-packages.nix) ];
    config = { allowUnfree = true; android_sdk.accept_license = true; };
  })

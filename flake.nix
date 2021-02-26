{
  description = "The nix lib I was missing";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, ... }@inputs: {
    lib = import ./default.nix {
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    };
    libDebug = { logLevel ? "disabled" }:
      import ./default.nix {
        inherit logLevel;
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      };
  };
}
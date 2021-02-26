{
  pkgs ? import <nixpkgs> {},
  lib ? pkgs.lib,
  logLevel ? "disabled",
}:

with builtins;
with pkgs.lib;

let
  importModule = name:
    import (./modules + "/${name}.nix") {
      inherit lib logLevel modules pkgs;
    };

  modules =
    let moduleNames = map (file: removeSuffix ".nix" file) (attrNames (readDir ./modules)); in
    listToAttrs (map (n: nameValuePair n (importModule n)) moduleNames);
in
foldl' (a: b: a // b) {} (attrValues modules)

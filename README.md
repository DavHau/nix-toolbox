## nix-toolbox - The nix lib I was missing
A collection of nix functions useful for debugging nix expressions

### Example:
```
nix repl

# import nix-toolbox lib
> l = (builtins.getFlake "github:davhau/nix-toolbox").lib

# conveniently fetch nixpkgs
> pkgs = l.importNixpkgs "f6b5bfdb4"

# show exact relation between two packages
> l.whyDepends pkgs.python3.pkgs.google-auth pkgs.python3.pkgs.six

```

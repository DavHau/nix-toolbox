{
  lib,
  modules,
  ...
}:

with builtins;
with lib;
with modules; with modules.logging;

rec {

    # import an arbitrary nixpkgs version in one line
    importNixpkgs = ref:
      (getFlake "nixpkgs/${ref}").legacyPackages.x86_64-linux;

    # reimport nixpkgs with additional config/overlays/system
    reimportNixpkgs = pkgs: opts:
      let 
        oldOpts = { inherit (pkgs) config system; };
      in
        import pkgs.path (recursiveUpdate oldOpts opts) // {
          overlays = pkgs.overlays + (opts.overlays or []);
        };

    # show all dependency paths from p1 to p2
    whyDepends = p1: p2:
      let 
        whyDepends' = p1: p2: path:
        flatten (map (n:
          let 
            deps = (p1."${n}" or []);
          in
            if elem p2 deps then
              logDebug "found: ${path}.${n}"
              "${path}.${n}"
            else
              map (p: 
                let newPath = "${path}.${n}.${toString(p.pname or p.name or p)}"; in
                logDebug "searching: ${newPath}"
                (whyDepends' p p2 "${newPath}")
              ) deps
        ) consts.depNames);
        in
      flatten (map (output: whyDepends' p1 p2."${output}" "") p2.outputs);

    # list all dependencies of a package (this can be slow)
    allDeps = pkg:
      unique (flatten (map (n:
        let 
          deps = (pkg."${n}" or []);
        in
          deps ++ (map (p: allDeps p) deps)
      ) consts.depNames));

    # like allDeps but returns attrs with package names as keys
    allDepsAttrs = pkg:
      listToAttrs (map (p: nameValuePair (p.pname or p.name or (toString p)) p ) (allDeps pkg));
  }
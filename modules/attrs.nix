{
  lib,
  ...
}:
with lib;
{
  reverseAttrs = attrs:
    mapAttrs' (n: v: nameValuePair (toString v) n) attrs;
}

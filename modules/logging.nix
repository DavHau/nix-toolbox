{
  lib,
  modules,
  logLevel ? "info",
  ...
}:
with lib;
let 
  levels = {
    disabled = 9999;
    critical = 50;
    error = 40;
    warning = 30;
    info = 20;
    debug = 10;
    notset = 0;
  };

  levelsReverse = modules.attrs.reverseAttrs levels;

  levelToInt = lvlNameOrInt:
    if isInt lvlNameOrInt then lvlNameOrInt
    else levels."${lvlNameOrInt}" or (trow "selected log level '${lvlNameOrInt}' unknown");

  runtimeLevel = levelToInt logLevel;

in
with lib;
let self = {
  # trace only if runtime debug level allows it
  # Useful to add some debugging output to nix evaluation
  log = level: toTrace: toEval:
    let
      l = levelToInt level;
      prefix =
        let rounded = toString ((l / 10) * 10); in
        "${toUpper (levelsReverse."${rounded}" or "DEBUG(${rounded})")}: ";
    in
      if l < runtimeLevel then toEval
      else trace "${prefix}${toTrace}" toEval;
}; in (self // (mapAttrs' (lvlName: lvlVal:
  nameValuePair "log${toUpper (substring 0 1 lvlName)}${substring 1 99 lvlName}" (self.log lvlVal)
) levels))

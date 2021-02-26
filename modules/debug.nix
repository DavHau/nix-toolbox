{
  lib,
  modules,
  ...
}:

rec {
  # like builtins.trace, but always converts to string
  trace = toTrace: builtins.trace (toString toTrace);

  # to trace exactly what is evaluated
  traceEval = toEval: trace toEval toEval;
}
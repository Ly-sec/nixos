{ desktop, lib, ... }:

{
  environment.variables = {
    XCURSOR_SIZE = "24";
  } // lib.optionalAttrs (desktop != "plasma") {
    QT_QPA_PLATFORM = "wayland";
  };
}

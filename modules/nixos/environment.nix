{ config, lib, ... }:

{
  environment.variables = {
    XCURSOR_SIZE = "24";
  }
  // lib.optionalAttrs (config.lysec.desktop != "plasma") {
    QT_QPA_PLATFORM = "wayland";
  };
}

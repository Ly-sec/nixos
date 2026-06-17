{ pkgs, inputs, ... }:

let
  fluxerCanary = inputs.fluxer.packages.${pkgs.stdenv.hostPlatform.system}.fluxer-canary;
in
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "fluxer-canary";
      runtimeInputs = [ fluxerCanary ];
      text = ''
        export ELECTRON_OZONE_PLATFORM_HINT=x11
        exec ${fluxerCanary}/bin/fluxer-canary "$@"
      '';
    })
  ];

  # Fluxer rewrites this with a broken direct opt/ path; keep it hidden since niri starts it.
  xdg.configFile."autostart/fluxer-canary.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Hidden=true
  '';
}

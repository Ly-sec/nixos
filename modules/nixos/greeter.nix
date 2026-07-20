{
  pkgs,
  vars,
  lib,
  inputs,
  ...
}:

let
  desktops = import ../../lib/desktops.nix;
  desktop = desktops.assertValid vars.desktop;
  useGreeter = desktops.usesGreetd desktop;
  greeterSession = desktops.greeterSession desktop;

  noctaliaGreeter =
    inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
      (old: {
        src = lib.cleanSourceWith {
          inherit (old) src;
          filter =
            path: _type:
            let
              base = baseNameOf path;
            in
            base != "build" && base != "build-release" && base != "build-asan";
        };
      });

  greeterToml = (pkgs.formats.toml { }).generate "greeter.toml" {
    greeter_user = "greeter";
    session = {
      default = greeterSession;
      last = greeterSession;
    };
    user = {
      default = vars.username;
    };
    appearance = {
      scheme = "Synced";
      password_style = "random";
    };
    cursor = {
      theme = "Bibata-Modern-Ice";
      size = 24;
      path = "${pkgs.bibata-cursors}/share/icons";
    };
    keyboard = {
      layout = "de";
    };
    output = {
      layout = "DP-1:0,0; DP-2:2560,0";
    };
  };
in
{
  imports = lib.optionals useGreeter [
    inputs.noctalia-greeter.nixosModules.default
    {
      programs.noctalia-greeter = {
        enable = true;
        package = noctaliaGreeter;
        greeter-args = "";
        settings.cursor = {
          theme = "Bibata-Modern-Ice";
          size = 24;
          path = "${pkgs.bibata-cursors}/share/icons";
        };
      };

      system.activationScripts.noctaliaGreeter = ''
        # State dir for greeter.toml / appearance; logging defaults to stderr.
        mkdir -p /var/lib/noctalia-greeter
        chown greeter:greeter /var/lib/noctalia-greeter 2>/dev/null || true
        chmod 0750 /var/lib/noctalia-greeter 2>/dev/null || true

        GREETD_CONFIG=/etc/greetd/config.toml \
          ${noctaliaGreeter}/bin/noctalia-greeter-apply-appearance --setup-system

        install -D -o greeter -g greeter -m 0644 ${greeterToml} /var/lib/noctalia-greeter/greeter.toml

        rm -f /var/lib/noctalia-greeter/greeter.conf
      '';
    }
  ];
}

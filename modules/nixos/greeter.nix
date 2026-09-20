{
  pkgs,
  config,
  lib,
  inputs,
  desktop,
  ...
}:

let
  desktops = import ../../lib/desktops.nix;
  useGreeter = desktops.usesGreetd desktop;
  greeterSession = desktops.greeterSession desktop;

  noctaliaGreeter =
    pkgs.noctalia-greeter.overrideAttrs (old: {
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

  greeterSettings = {
    greeter_user = "greeter";
    session = {
      default = greeterSession;
      last = greeterSession;
    };
    user = {
      default = config.lysec.username;
    };
    appearance = {
      scheme = "Synced";
      password_style = "random";
    };
    cursor = {
      theme = config.lysec.cursor.theme;
      size = 24;
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
      services.displayManager.noctalia-greeter = {
        enable = true;
        package = noctaliaGreeter;
        passwordless-sync-users = [ config.lysec.username ];
        greeter-args = "";
        cursorTheme.package = config.lysec.cursor.package;
        settings = greeterSettings;
      };

      # The module owns greeter.toml; only the synchronized UI state is mutable.
      systemd.tmpfiles.settings."10-noctalia-greeter"."/var/lib/noctalia-greeter/sync.toml".f = {
        user = "greeter";
        group = "greeter";
        mode = "0640";
      };
    }
  ];
}

{ lib, ... }:

let
  desktops = import ../../lib/desktops.nix;
in
{
  options.lysec = {
    username = lib.mkOption {
      type = lib.types.str;
      description = "Primary user account name.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      description = "Networking hostname.";
    };

    stateVersion = lib.mkOption {
      type = lib.types.str;
      description = "NixOS / home-manager stateVersion";
    };

    system = lib.mkOption {
      type = lib.types.str;
      description = "Nixpkgs system string";
    };

    desktop = lib.mkOption {
      type = lib.types.enum desktops.names;
      description = "Active compositor / desktop session";
    };

    git = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Git user.name";
      };

      email = lib.mkOption {
        type = lib.types.str;
        description = "Git user.email";
      };

      signingKey = lib.mkOption {
        type = lib.types.str;
        description = "OpenPGP signing key id";
      };
    };
  };
}

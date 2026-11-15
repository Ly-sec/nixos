{
  flake.modules.homeManager.development = {
    lib,
    pkgs,
    ...
  }: let
    toolchain = {
      CC = "ccache gcc";
      CXX = "ccache g++";
    };
    # Run after nix develop has selected the project's compiler.
    withCcache = pkgs.writeShellApplication {
      name = "with-ccache";
      runtimeInputs = [pkgs.ccache];
      text = ''
        if (( $# == 0 )); then
          echo "Usage: with-ccache COMMAND [ARGS...]" >&2
          exit 2
        fi

        for variable in CC CXX; do
          compiler="''${!variable:-}"
          if [[ -z "$compiler" ]]; then
            if [[ "$variable" == CC ]]; then
              compiler=gcc
            else
              compiler=g++
            fi
          fi
          case "$compiler" in
            ccache\ *|*/ccache\ *) ;;
            *)
              printf -v "$variable" '%s %s' ${lib.escapeShellArg (lib.getExe pkgs.ccache)} "$compiler"
              export "''${variable?}"
              ;;
          esac
        done

        exec "$@"
      '';
    };
  in {
    home.packages = [pkgs.gcc16 pkgs.llvmPackages_23.clang-tools pkgs.ccache withCcache];

    xdg.configFile = {
      "environment.d/50-toolchain.conf".text =
        lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "${name}=${value}") toolchain) + "\n";
      # Nix compiler wrappers have normalized timestamps; hash their contents.
      "ccache/ccache.conf".text = ''
        compiler_check = content
      '';
    };

    # Cover Fish sessions started outside systemd without replacing a dev shell's
    # explicit compiler selection.
    programs.fish = {
      shellInit = lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value: ''
          if not set -q ${name}
            set -gx ${name} ${lib.escapeShellArg value}
          end
        '')
        toolchain);

      functions.nix = {
        wraps = "nix";
        description = "Nix with automatic compiler caching in development shells";
        body = ''
          if test "$argv[1]" != develop
            command nix $argv
            return $status
          end

          set -l index 2
          while test $index -le (count $argv)
            switch $argv[$index]
              case -c --command
                if test $index -lt (count $argv)
                  set -l rest (math $index + 1)
                  command nix $argv[1..$index] ${lib.getExe withCcache} $argv[$rest..-1]
                else
                  command nix $argv
                end
                return $status
              case --help -h --version --phase --unpack --configure --build --check --install --installcheck
                # Keep help and derivation phases unchanged.
                command nix $argv
                return $status
              case --arg --argstr --arg-from-file --override-input --override-flake --option --redirect --set-env-var -s
                set index (math $index + 2)
              case --expr --file -f --profile --store --eval-store --include -I --inputs-from --keep-env-var -k --unset-env-var -u --arg-from-stdin --output-lock-file --reference-lock-file --update-input
                set index (math $index + 1)
            end
            set index (math $index + 1)
          end

          command nix $argv --command ${lib.getExe withCcache} bash -i
        '';
      };
    };
  };
}

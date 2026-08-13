{ pkgs, lib, config, ... }:

let
  secretFile = "/run/agenix/noctalia-i18n-push";
  fishSingleQuotePath = s: "'${lib.replaceStrings [ "'" ] [ "'\\''" ] s}'";

  tideVarsRaw = builtins.readFile ./fish/fish_variables;
  tideVarsHash = builtins.hashString "sha256" (tideVarsRaw + ":v4-fish-lists");

  setuvarLines = lib.filter (l: lib.hasPrefix "SETUVAR " l) (lib.splitString "\n" tideVarsRaw);

  splitSetuvar = line:
    let
      rest = lib.removePrefix "SETUVAR " line;
      parts = lib.splitString ":" rest;
      name = builtins.head parts;
      value = lib.concatStringsSep ":" (lib.drop 1 parts);
    in
    { inherit name value; };

  # Tide rebuilds these from tide_*_prompt_items on startup.
  skipVars = [
    "_tide_left_items"
    "_tide_right_items"
  ];

  # \x1e-separated values must become fish lists, not a single string.
  listVars = [
    "tide_left_prompt_items"
    "tide_right_prompt_items"
    "tide_docker_default_contexts"
    "tide_pwd_markers"
  ];

  fishSingleQuote = s: "'${lib.replaceStrings [ "'" ] [ "'\\''" ] s}'";

  setUniversalVar =
    item:
    if builtins.elem item.name skipVars then
      ""
    else if builtins.elem item.name listVars then
      "set -U ${item.name} (string split \\x1e -- (printf '%b' ${fishSingleQuote item.value}))"
    else if lib.hasInfix "\\" item.value then
      "set -U ${item.name} (printf '%b' ${fishSingleQuote item.value})"
    else
      "set -U ${item.name} ${fishSingleQuote item.value}";

  tideVarInit = lib.concatStringsSep "\n" (
    lib.filter (s: s != "") (map setUniversalVar (map splitSetuvar setuvarLines))
  );

in
{
  programs.fish = {
    enable = true;
    plugins = [
      { name = "tide"; src = pkgs.fishPlugins.tide.src; }
    ];
    interactiveShellInit =
      (builtins.readFile ./fish/config.fish)
      + ''

        if status is-interactive; and test -r ${fishSingleQuotePath secretFile}
          set -gx NOCTALIA_TRANSLATION_PUSH_SECRET (string trim (cat ${fishSingleQuotePath secretFile}))
        end
      ''
      + ''

        if status is-interactive; and test "$__nixos_tide_vars_hash" != "${tideVarsHash}"
          set -U __nixos_tide_vars_hash ${tideVarsHash}
          ${tideVarInit}
        end
      '';
    functions.fish_user_key_bindings.body = builtins.readFile ./fish/fish_user_key_bindings.fish;
  };

  # fish_variables must be writable; a nix-store symlink breaks universal var updates
  home.activation.removeManagedFishVariables = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    fish_vars="${config.home.homeDirectory}/.config/fish/fish_variables"
    if [ -L "$fish_vars" ] && readlink "$fish_vars" | grep -q '^/nix/store/'; then
      $DRY_RUN_CMD rm -f "$fish_vars"
    fi
  '';

  home.activation.generateNoctaliaFishCompletions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    completions_dir="${config.home.homeDirectory}/.config/fish/completions"
    $DRY_RUN_CMD mkdir -p "$completions_dir"
    $DRY_RUN_CMD ${config.lysec.noctaliaPackage}/bin/noctalia completions fish > "$completions_dir/noctalia.fish"
  '';
}

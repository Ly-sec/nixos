{
  config,
  lib,
  pkgs,
  ...
}:

let
  kittyConfig = "${config.xdg.configHome}/kitty/kitty.conf";
in
{
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };

    settings = {
      disable_ligatures = "always";
      hide_window_decorations = true;
      include = "themes/noctalia.conf";
    };
  };

  # Noctalia updates and touches kitty.conf before signaling Kitty to reload.
  # Detach Home Manager's store symlink so that file remains writable.
  xdg.configFile."kitty/kitty.conf".force = true;
  home.activation.makeKittyConfigWritable = lib.hm.dag.entryAfter [ "onFilesChange" ] ''
    kittyConfig=${lib.escapeShellArg kittyConfig}
    if [ -L "$kittyConfig" ]; then
      target="$(${pkgs.coreutils}/bin/readlink -f "$kittyConfig")"
      case "$target" in
        /nix/store/*)
          $DRY_RUN_CMD ${pkgs.coreutils}/bin/cp --remove-destination "$target" "$kittyConfig"
          $DRY_RUN_CMD ${pkgs.coreutils}/bin/chmod u+w "$kittyConfig"
          ;;
      esac
    fi
  '';
}

{
  config,
  lib,
  pkgs,
  ...
}: let
  emacs = config.programs.emacs.finalPackage;
  emacsDir = "${config.xdg.configHome}/emacs";
  stateDir = "${config.xdg.stateHome}/emacs";
  doomDir = "${config.xdg.configHome}/doom";
  tools = pkgs.buildEnv {
    name = "emacs-tools";
    pathsToLink = ["/bin"];
    paths = with pkgs; [
      git
      fd
      ripgrep
      direnv
      nixd
      alejandra
      llvmPackages_23.clang-tools
      nim
      nimlsp
      shfmt
      prettier
      cmark-gfm
      wl-clipboard
    ];
  };
  launcher = pkgs.writeShellScriptBin "emacs" ''
    args=()
    for arg in "$@"; do
      case "$arg" in
        --batch|-Q|-q|--no-init-file|--daemon*|--fg-daemon*|--version|--help)
          exec ${emacs}/bin/emacs "$@"
          ;;
        -nw|--no-window-system) ;;
        *) args+=("$arg") ;;
      esac
    done
    ${pkgs.systemd}/bin/systemctl --user start emacs.service
    exec ${emacs}/bin/emacsclient --tty "''${args[@]}"
  '';
in {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-nox;
    extraPackages = epkgs:
      with epkgs; [
        meow
        undo-fu-session
        vertico
        orderless
        marginalia
        consult
        corfu
        cape
        nerd-icons
        nerd-icons-completion
        treemacs
        treemacs-nerd-icons
        dirvish
        envrc
        nix-mode
        nim-mode
        apheleia
        magit
        blamer
        diff-hl
        hl-todo
        rainbow-delimiters
        markdown-mode
        org-modern
        org-appear
        org-roam
        elcord
      ];
  };

  services.emacs = {
    enable = true;
    startWithUserSession = true;
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    enableGitIntegration = true;
    nix-direnv.enable = true;
  };

  home.packages = [
    (lib.hiPrio launcher)
    (pkgs.writeShellScriptBin "emacs-standalone" ''
      exec ${emacs}/bin/emacs -nw "$@"
    '')
    tools
  ];

  xdg.configFile = {
    "emacs/init.el" = {
      source = ./init.el;
      force = true;
    };
    "emacs/early-init.el" = {
      source = ./early-init.el;
      force = true;
    };
    "emacs/lisp" = {
      source = ./lisp;
      recursive = true;
      force = true;
    };
    "emacs/paths.el".text = ''
      ;;; paths.el -*- lexical-binding: t -*-
      (defvar lysec-tools-directory "${tools}/bin")
      (defvar lysec-keybindings-file "${config.home.homeDirectory}/nixos/home/programs/emacs/org/keybindings.org")
    '';
  };

  home.activation.retireDoom = lib.hm.dag.entryBetween ["linkGeneration"] ["writeBoundary"] ''
    emacsDir=${lib.escapeShellArg emacsDir}
    doomDir=${lib.escapeShellArg doomDir}
    stateDir=${lib.escapeShellArg stateDir}
    if [ -f "$emacsDir/bin/doom" ]; then
      $DRY_RUN_CMD mkdir -p "$stateDir/retired"
      if [ -z "''${DRY_RUN_CMD:-}" ]; then
        archive=$(${pkgs.coreutils}/bin/mktemp -d "$stateDir/retired/doom.XXXXXX")
        mv "$emacsDir" "$archive/emacs"
        if [ -d "$doomDir" ]; then
          mv "$doomDir" "$archive/doom"
        fi
        mkdir -p "$emacsDir/themes"
        if [ -f "$archive/doom/themes/noctalia-theme.el" ]; then
          cp "$archive/doom/themes/noctalia-theme.el" "$emacsDir/themes/"
        fi
      fi
    fi
  '';

  # Noctalia writes this theme at runtime, so it cannot be a store symlink.
  home.activation.seedEmacsTheme = lib.hm.dag.entryBetween ["reloadSystemd"] ["retireDoom" "linkGeneration"] ''
    themeDir=${lib.escapeShellArg "${emacsDir}/themes"}
    $DRY_RUN_CMD mkdir -p "$themeDir"
    if [ ! -f "$themeDir/noctalia-theme.el" ]; then
      $DRY_RUN_CMD cp ${./themes/noctalia-theme.el} "$themeDir/noctalia-theme.el"
    fi
    $DRY_RUN_CMD chmod u+w "$themeDir/noctalia-theme.el"
  '';

  home.activation.freshEmacsOrg = lib.hm.dag.entryAfter ["writeBoundary"] ''
    stateDir=${lib.escapeShellArg stateDir}
    $DRY_RUN_CMD mkdir -p "$stateDir"
    if [ ! -f "$stateDir/org-migrated" ] && [ -z "''${DRY_RUN_CMD:-}" ]; then
      if [ -d /mnt/storage/org ]; then
        archive=$(${pkgs.coreutils}/bin/mktemp -d /mnt/storage/org-retired.XXXXXX)
        mv /mnt/storage/org "$archive/old"
      fi
      mkdir -p /mnt/storage/org/notes /mnt/storage/org/journal
      cp ${./org/inbox.org} /mnt/storage/org/inbox.org
      cp ${./org/tasks.org} /mnt/storage/org/tasks.org
      chmod u+w /mnt/storage/org/inbox.org /mnt/storage/org/tasks.org
      touch "$stateDir/org-migrated"
    fi
  '';
}

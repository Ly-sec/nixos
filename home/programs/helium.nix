{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
  heliumUnwrapped = inputs.helium.packages.${system}.helium-widevine;
  helium = heliumUnwrapped.overrideAttrs (oldAttrs: {
    # Helium disables middle-click autoscroll on Linux by default. Keep its
    # native implementation enabled for every way the browser is launched,
    # and modestly enlarge the entire browser UI (including tab titles).
    postFixup = (oldAttrs.postFixup or "") + ''
      wrapProgram "$out/bin/helium" \
        --add-flags "--enable-features=HeliumMiddleClickAutoscroll" \
        --add-flags "--force-device-scale-factor=1.1"
    '';
  });
  widevine = "${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm";
  heliumDesktop = [ "helium.desktop" ];
  heliumProfileDir = "${config.xdg.configHome}/net.imput.helium/Default";
  heliumPreferences = "${heliumProfileDir}/Preferences";
  heliumSingletonLock = "${config.xdg.configHome}/net.imput.helium/SingletonLock";
in
{
  home = {
    packages = [ helium ];
    sessionVariables.BROWSER = lib.getExe helium;
  };

  xdg.configFile."net.imput.helium/WidevineCdm/latest-component-updated-widevine-cdm".text =
    builtins.toJSON { Path = widevine; };

  # Helium exposes this as a normal profile preference rather than an enterprise
  # policy. Converge it during activation, but never rewrite Preferences while
  # the browser owns the profile.
  home.activation.disableHeliumRoundedFrame = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    preferences=${lib.escapeShellArg heliumPreferences}
    profileDir=${lib.escapeShellArg heliumProfileDir}
    singletonLock=${lib.escapeShellArg heliumSingletonLock}

    if [ -n "''${DRY_RUN_CMD:-}" ]; then
      echo "Would disable Helium's rounded web-content frame"
    elif [ -e "$singletonLock" ] || [ -L "$singletonLock" ]; then
      echo "warning: Helium is running; close it and activate again to disable its rounded frame" >&2
    else
      ${pkgs.coreutils}/bin/mkdir -p "$profileDir"
      temporary="$(${pkgs.coreutils}/bin/mktemp "$profileDir/.Preferences.XXXXXX")"
      trap '${pkgs.coreutils}/bin/rm -f "$temporary"' EXIT

      if [ -f "$preferences" ]; then
        ${pkgs.jq}/bin/jq '.helium.browser.rounded_frame = false' "$preferences" > "$temporary"
        ${pkgs.coreutils}/bin/chmod --reference="$preferences" "$temporary"
      else
        ${pkgs.jq}/bin/jq -n '.helium.browser.rounded_frame = false' > "$temporary"
        ${pkgs.coreutils}/bin/chmod 600 "$temporary"
      fi

      if [ -f "$preferences" ] && ${pkgs.diffutils}/bin/cmp -s "$preferences" "$temporary"; then
        ${pkgs.coreutils}/bin/rm -f "$temporary"
      else
        ${pkgs.coreutils}/bin/mv "$temporary" "$preferences"
      fi
      trap - EXIT
    fi
  '';

  xdg.mimeApps = {
    enable = true;
    defaultApplicationPackages = [ helium ];

    defaultApplications = {
      "application/vnd.mozilla.xul+xml" = heliumDesktop;
      "x-scheme-handler/about" = heliumDesktop;
      "x-scheme-handler/unknown" = heliumDesktop;

      # Preserve the existing application-specific handlers when Home Manager
      # takes ownership of mimeapps.list.
      "x-scheme-handler/discord" = [ "vesktop.desktop" ];
      "x-scheme-handler/fluxer" = [ "fluxer-canary.desktop" ];
    };

    associations.added."x-scheme-handler/discord" = [ "vesktop.desktop" ];
  };
}

rec {
  names = [
    "niri"
    "hyprland"
    "sway"
    "labwc"
    "mango"
    "plasma"
  ];

  usesGreetd = desktop: desktop != "plasma";

  greetdSession = desktop: pkgs:
    let
      tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
      flags = "--remember --asterisks --container-padding 2 --no-xsession-wrapper";
      sessions = {
        niri = "niri-session";
        hyprland = "Hyprland";
        sway = "sway";
        labwc = "labwc";
        mango = "mangowc";
      };
    in
    "${tuigreet} ${flags} --cmd ${sessions.${desktop}}";

  assertValid = desktop:
    if builtins.elem desktop names then
      desktop
    else
      builtins.throw "Unknown desktop '${desktop}'. Expected one of: ${builtins.concatStringsSep ", " names}";

}

rec {
  names = [
    "niri"
    "umbriel"
    "hyprland"
    "sway"
    "labwc"
    "mango"
    "plasma"
  ];

  usesGreetd = desktop: desktop != "plasma";

  # wayland-sessions .desktop Name= values for noctalia-greeter --session
  greeterSession = desktop:
    {
      niri = "Niri";
      umbriel = "Umbriel";
      hyprland = "Hyprland";
      sway = "sway";
      labwc = "labwc";
      mango = "MangoWC";
    }
    .${desktop};

  assertValid = desktop:
    if builtins.elem desktop names then
      desktop
    else
      builtins.throw "Unknown desktop '${desktop}'. Expected one of: ${builtins.concatStringsSep ", " names}";

}

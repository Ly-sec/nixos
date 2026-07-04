{ pkgs, inputs, vars, lib, noctaliaPackage, ... }:

let
  ghostty = "${pkgs.ghostty}/bin/ghostty";
  firefox = "${pkgs.firefox}/bin/firefox";
  noctalia = lib.getExe noctaliaPackage;
  exec = cmd: lib.generators.mkLuaInline "hl.dsp.exec_cmd(${lib.generators.toLua { } cmd})";
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    package = null;
    portalPackage = null;
    xwayland.enable = true;

    settings = {
      mod = {
        _var = "SUPER";
      };

      monitor = [
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = 1;
        }
      ];

      env = [
        {
          _args = [
            "XCURSOR_SIZE"
            "24"
          ];
        }
        {
          _args = [
            "XCURSOR_THEME"
            "Bibata-Modern-Ice"
          ];
        }
      ];

      config = {
        input = {
          kb_layout = "de";
          numlock_by_default = true;
          follow_mouse = 1;
          touchpad = {
            natural_scroll = true;
          };
        };

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          layout = "dwindle";
        };

        decoration = {
          rounding = 8;
        };
      };

      bind = [
        {
          _args = [
            "SUPER + RETURN"
            (exec ghostty)
          ];
        }
        {
          _args = [
            "SUPER + B"
            (exec firefox)
          ];
        }
        {
          _args = [
            "SUPER + CTRL + RETURN"
            (exec "${noctalia} msg panel-toggle launcher")
          ];
        }
        {
          _args = [
            "SUPER + Q"
            (lib.generators.mkLuaInline "hl.dsp.window.close()")
          ];
        }
        {
          _args = [
            "SUPER + M"
            (lib.generators.mkLuaInline "hl.dsp.exit()")
          ];
        }
      ] ++ (
        builtins.concatLists (builtins.genList (
            x: let
              ws = builtins.toString (x + 1);
            in [
              {
                _args = [
                  "SUPER + ${ws}"
                  (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = ${ws} })")
                ];
              }
              {
                _args = [
                  "SUPER + SHIFT + ${ws}"
                  (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = ${ws} })")
                ];
              }
            ]
          )
          9)
      );

      on = {
        _args = [
          "hyprland.start"
          (lib.generators.mkLuaInline ''
            function()
              hl.exec_cmd(${lib.generators.toLua { } noctalia})
            end
          '')
        ];
      };
    };
  };
}

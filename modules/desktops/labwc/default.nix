{config, ...}: {
  flake.modules.nixos."desktop-labwc" = {...}: {
    home-manager.sharedModules = [config.flake.modules.homeManager."desktop-labwc"];
    programs.labwc.enable = true;
  };
  flake.modules.homeManager."desktop-labwc" = {
    pkgs,
    lib,
    config,
    ...
  }: let
    kitty = "${pkgs.kitty}/bin/kitty";
    browser = config.home.sessionVariables.BROWSER;
    noctalia = lib.getExe pkgs.noctalia;
    luciole = lib.getExe pkgs.luciole;

    workspaceKeybinds = lib.concatMapStringsSep "\n" (i: ''
      <keybind key="W-${toString i}">
        <action name="GoToDesktop" to="${toString i}" />
      </keybind>
      <keybind key="W-C-${toString i}">
        <action name="SendToDesktop" to="${toString i}" />
      </keybind>
    '') (lib.range 1 9);
  in {
    xdg.configFile."labwc/environment".text = ''
      XKB_DEFAULT_LAYOUT=de
    '';

    xdg.configFile."labwc/autostart".source = pkgs.writeShellScript "labwc-autostart" ''
      "${config.xdg.configHome}/labwc/outputs.sh"
      ${noctalia} &
    '';

    xdg.configFile."labwc/rc.xml".text = ''
      <labwc_config>
        <desktops number="9" />

        <keyboard>
          <default />
          <numlock>on</numlock>
          <keybind key="W-Return">
            <action name="Execute" command="${kitty}" />
          </keybind>
          <keybind key="W-b">
            <action name="Execute" command="${browser}" />
          </keybind>
          <keybind key="W-C-Return">
            <action name="Execute" command="${noctalia} msg panel-toggle launcher" />
          </keybind>
          <keybind key="W-e">
            <action name="Execute" command="${luciole}" />
          </keybind>
          <keybind key="W-q">
            <action name="Close" />
          </keybind>
          ${workspaceKeybinds}
        </keyboard>

        <libinput>
          <device category="touchpad">
            <naturalScroll>yes</naturalScroll>
          </device>
        </libinput>

        <mouse>
          <default />
          <context name="All">
            <mousebind direction="W-Up" action="Scroll">
              <action name="GoToDesktop" to="left" />
            </mousebind>
            <mousebind direction="W-Down" action="Scroll">
              <action name="GoToDesktop" to="right" />
            </mousebind>
          </context>
        </mouse>
      </labwc_config>
    '';
  };
}

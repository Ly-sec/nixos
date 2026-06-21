{ pkgs, vars, lib, noctaliaPackage, ... }:

let
  ghostty = "${pkgs.ghostty}/bin/ghostty";
  firefox = "${pkgs.firefox}/bin/firefox";
  wlr-randr = "${pkgs.wlr-randr}/bin/wlr-randr";
  noctalia = lib.getExe noctaliaPackage;

  workspaceKeybinds =
    lib.concatMapStringsSep "\n" (i: ''
      <keybind key="W-${toString i}">
        <action name="GoToDesktop" to="${toString i}" />
      </keybind>
      <keybind key="W-C-${toString i}">
        <action name="SendToDesktop" to="${toString i}" />
      </keybind>
    '')
    (lib.range 1 9);
in
{
  xdg.configFile."labwc/environment".text = ''
    XKB_DEFAULT_LAYOUT=de
  '';

  xdg.configFile."labwc/autostart".source =
    pkgs.writeShellScript "labwc-autostart" ''
      ${pkgs.xwayland-satellite}/bin/xwayland-satellite &
      ${wlr-randr} --output DP-1 --mode 2560x1440@359.979Hz
      ${wlr-randr} --output DP-2 --mode 1920x1080@164.917Hz
      ${noctalia} &
    '';

  xdg.configFile."labwc/rc.xml".text = ''
    <labwc_config>
      <desktops number="9" />

      <keyboard>
        <default />
        <numlock>on</numlock>
        <keybind key="W-Return">
          <action name="Execute" command="${ghostty}" />
        </keybind>
        <keybind key="W-b">
          <action name="Execute" command="${firefox}" />
        </keybind>
        <keybind key="W-C-Return">
          <action name="Execute" command="${noctalia} msg panel-toggle launcher" />
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
}

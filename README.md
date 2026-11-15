<h1 align="center">lysec / nixos</h1>

<p align="center">
  My everyday desktop, built around <a href="modules/desktops/umbriel"><strong>Umbriel</strong></a>
  and <a href="modules/programs/noctalia"><strong>Noctalia</strong></a>.
</p>

<p align="center">
  <a href="flake.nix"><img alt="NixOS unstable" src="https://img.shields.io/badge/NixOS-unstable-adc178?style=flat-square&amp;logo=nixos&amp;logoColor=adc178&amp;labelColor=0b1822"></a>
  <a href="modules/users/lysec"><img alt="Home Manager" src="https://img.shields.io/badge/Home_Manager-0b1822?style=flat-square&amp;logoColor=adc178"></a>
  <a href="modules/system/base.nix"><img alt="Dendritic flake-parts" src="https://img.shields.io/badge/flake--parts-dendritic-adc178?style=flat-square&amp;labelColor=0b1822"></a>
</p>

![Umbriel and Noctalia desktop](https://i.imgur.com/YehAwnl.jpeg)

<table>
  <tr>
    <td width="50%" valign="top">
      <h3>Umbriel</h3>
      <p>Keyboard-driven windows, scratchpads, and a layout across two monitors.</p>
    </td>
    <td width="50%" valign="top">
      <h3>Noctalia</h3>
      <p>The bar, launcher, lock screen, and screenshot annotation. Its palette carries through the apps, icons, and cursor.</p>
    </td>
  </tr>
  <tr>
    <td valign="top">
      <a href="modules/desktops/umbriel">Desktop configuration →</a>
    </td>
    <td valign="top">
      <a href="modules/programs/noctalia">Shell configuration →</a>
    </td>
  </tr>
</table>

**Apps** · [Kitty](modules/programs/kitty.nix) · [Fish + Tide](modules/programs/fish)
· [Emacs](modules/programs/emacs) · [VS Code](modules/programs/vscode.nix)
· [Helium](modules/programs/helium) · [Firefox](modules/programs/firefox)
· [Sonora](modules/programs/sonora.nix)

<details>
<summary>Build and desktop selection</summary>

From this checkout:

```sh
nh os build path:.
nh os switch path:.
```

Niri, Hyprland, Sway, Labwc, Mango, and Plasma are also configured.
The active desktop is set in [host settings](modules/hosts/nixos/settings.nix).

Some inputs use my local development checkouts. Their paths are in
[flake.nix](flake.nix).

</details>

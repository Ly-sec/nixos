# nixos

My NixOS config. Umbriel + Noctalia, with Home Manager and flake-parts.

![Desktop](https://i.imgur.com/YehAwnl.jpeg)

|               |                                       |
| ------------- | ------------------------------------- |
| Compositor    | [Umbriel](modules/desktops/umbriel)   |
| Desktop shell | [Noctalia](modules/programs/noctalia) |
| Terminal      | Kitty                                 |
| Shell         | Fish + Tide                           |
| Editors       | Emacs, VS Code                        |
| Browsers      | Helium, Firefox                       |
| Music         | Sonora                                |

Noctalia handles the colors, icons and cursor.

Umbriel is my main desktop. There are also configs for Niri, Hyprland, Sway, Labwc, Mango and Plasma.

The desktop is set in [host settings](modules/hosts/nixos/settings.nix).

Build or switch from this checkout:

```sh
nh os build path:.
nh os switch path:.
```

Some inputs use my local checkouts. The paths are in [flake.nix](flake.nix).

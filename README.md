![NixOS Configuration](https://i.imgur.com/4PyePGk.jpeg)

# nixos

Personal NixOS flake, one host, home-manager, several Wayland compositors, secrets via agenix.

## Quick start

```bash
nh os switch path:.
```

Checkout expected at `~/nixos`.

## Layout

```
flake.nix                 inputs + nixosConfigurations.nixos
hosts/nixos/              host settings, hardware, storage, and entrypoint
modules/lysec/            shared options and cursor configuration
modules/nixos/            system modules (boot, greeter, networking, …)
desktops/<name>/          per-compositor nixos + home
home/                     shared HM (program index, editors, shell, packages)
overlays/                 packages normalized from flake inputs
secrets/                  encrypted .age files + recipients (secrets.nix)
lib/                      desktop metadata helpers
```

## Settings (`lysec.*`)

The reusable option declarations live in [`modules/lysec/options.nix`](modules/lysec/options.nix), while this machine's values live in [`hosts/nixos/settings.nix`](hosts/nixos/settings.nix). To switch compositors, change `desktop` in the host settings:

```nix
desktop = "niri";
```

| Option                                                    | Meaning                                                                          |
| --------------------------------------------------------- | -------------------------------------------------------------------------------- |
| `lysec.desktop`                                           | Active session: `niri` (default), `hyprland`, `sway`, `labwc`, `mango`, `plasma` |
| `lysec.git.*`                                             | Commit identity + signing key                                                    |
| `lysec.username` / `hostname` / `stateVersion` / `system` | Host identity                                                                    |

Only the chosen desktop’s `desktops/<name>/nixos.nix` is imported at build time.

## Desktops

Non-Plasma sessions use **greetd** + **Noctalia Greeter** ([`modules/nixos/greeter.nix`](modules/nixos/greeter.nix)). Plasma uses SDDM via [`desktops/plasma/nixos.nix`](desktops/plasma/nixos.nix).

| Desktop                         | Notes                                                 |
| ------------------------------- | ----------------------------------------------------- |
| **niri**                        | Full setup, keybinds, rules, animations, autostart    |
| hyprland / sway / labwc / mango | Lighter stubs + Noctalia; mango has a custom session  |
| plasma                          | KDE stack; Noctalia via XDG autostart after the panel |

Shared Wayland defaults (cursor, Electron/Qt hints): [`desktops/shared/home.nix`](desktops/shared/home.nix).

## Home

[`home/default.nix`](home/default.nix) pulls in the active desktop, Doom/VS Code, fish, and the programs explicitly listed in [`home/programs/default.nix`](home/programs/default.nix).

Notable pieces: fish + tide, Helium, Kitty, Fluxer, Vesktop, signed git (GPG from agenix), Doom under `home/doom/`.

## Secrets (agenix)

Encrypted blobs in `secrets/*.age` decrypt at activation to `/run/agenix/`. Recipients are declared in [`secrets/secrets.nix`](secrets/secrets.nix) (host SSH pubkey + recovery age key).

```bash
cd ~/nixos/secrets
agenix -i ~/.config/age/keys.txt -e <name>.age
nh os switch ~/nixos
```

Do not commit `~/.config/age/keys.txt`. Back it up offline.

## Local project inputs

Noctalia, its greeter, and Umbriel are path inputs pointing at the development checkouts under `/mnt/storage`. After editing one of them, refresh its lock entry and rebuild:

```bash
nix flake update noctalia noctalia-greeter umbriel
nh os switch path:.
```

The repository intentionally depends on those local paths and will not evaluate on a machine without them.

## Inputs

`nixpkgs` (unstable), `home-manager`, `niri`, `agenix`, `xwayland-satellite`, `fluxer`, `helium`, `swash`, `doomemacs`, `nur`, plus the local Noctalia, Noctalia Greeter, and Umbriel path inputs.

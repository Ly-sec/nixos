![NixOS Configuration](https://i.imgur.com/YehAwnl.jpeg)

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
desktop = "umbriel";
```

| Option                                                    | Meaning                                                                                     |
| --------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| `lysec.desktop`                                           | Active session: `umbriel` (default), `niri`, `hyprland`, `sway`, `labwc`, `mango`, `plasma` |
| `lysec.git.*`                                             | Commit identity + signing key                                                               |
| `lysec.username` / `hostname` / `stateVersion` / `system` | Host identity                                                                               |

Only the chosen desktop’s `desktops/<name>/nixos.nix` is imported at build time.

## Desktops

Non-Plasma sessions use **greetd** + **Noctalia Greeter** ([`modules/nixos/greeter.nix`](modules/nixos/greeter.nix)). Plasma uses SDDM via [`desktops/plasma/nixos.nix`](desktops/plasma/nixos.nix).

| Desktop                         | Notes                                                  |
| ------------------------------- | ------------------------------------------------------ |
| **umbriel** (default)           | Full setup, keybinds, rules, animations, autostart etc |
| niri                            | Full setup, keybinds, rules, animations, autostart     |
| hyprland / sway / labwc / mango | Lighter stubs + Noctalia; mango has a custom session   |
| plasma                          | KDE stack; Noctalia via XDG autostart after the panel  |

Shared Wayland defaults (cursor, Electron/Qt hints): [`desktops/shared/home.nix`](desktops/shared/home.nix).

`Super+E` opens Luciole on every desktop, using the local flake at `/mnt/storage/GitHub/noctalia-dev/luciole`. Plasma assigns the shortcut to Luciole's desktop entry and disables Dolphin's competing default.

## Home

[`home/default.nix`](home/default.nix) pulls in the active desktop, VS Code, fish, and the programs explicitly listed in [`home/programs/default.nix`](home/programs/default.nix).

Emacs is configured in [`home/programs/emacs/`](home/programs/emacs/), with Meow editing, Nix-managed packages, and a user daemon. Notes live in `/mnt/storage/org/`. `SPC h b` opens the [key guide](home/programs/emacs/org/keybindings.org) directly from `~/nixos/` in a pane on the right.

Gruvbox Plus icons follow Noctalia's palette through [`home/programs/noctalia/icons.nix`](home/programs/noctalia/icons.nix). Colored app icons link directly to the installed originals, preserving logos and avoiding recoloring or copying them during theme changes. Monochrome icons adapt fully to the foreground, folder highlights use the primary accent, and neutral shading adapts to dark and light mode. Noctalia renders the palette and generates the icons in a background hook, then selects the completed theme through GSettings. GTK's settings files retain the installed Gruvbox Plus theme as a fallback; Noctalia owns the live GSettings selection so rebuilds do not reset it.

Generated themes live in `$XDG_DATA_HOME/icons` (default `~/.local/share/icons`). Four palettes are retained, including the current and previous themes; revisiting one reuses its files. Package, generator, and palette changes invalidate the cache. To reapply the last rendered palette manually:

```bash
generate-noctalia-icons "${XDG_CONFIG_HOME:-$HOME/.config}/noctalia/gruvbox-icons.json"
```

## Secrets (agenix)

Encrypted blobs in `secrets/*.age` decrypt at activation to `/run/agenix/`. Recipients are declared in [`secrets/secrets.nix`](secrets/secrets.nix) (host SSH pubkey + recovery age key).

```bash
cd ~/nixos/secrets
agenix -i ~/.config/age/keys.txt -e <name>.age
nh os switch ~/nixos
```

Do not commit `~/.config/age/keys.txt`. Back it up offline.

## Local project inputs

Luciole, Noctalia, its greeter, and Umbriel are path inputs pointing at the development checkouts under `/mnt/storage`. The Noctalia overlay calls its package expression directly with `rev = "local"`, because path inputs do not provide Git revision metadata. After editing a local project, refresh its lock entry and rebuild:

```bash
nix flake update luciole noctalia noctalia-greeter umbriel
nh os switch path:.
```

The repository intentionally depends on those local paths and will not evaluate on a machine without them.

## Inputs

`nixpkgs` (unstable), `home-manager`, `niri`, `agenix`, `helium`, `swash`, `nur`, plus the local Luciole, Umbriel, Noctalia, and Noctalia Greeter path inputs.

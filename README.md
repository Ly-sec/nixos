![NixOS Configuration](https://i.imgur.com/4PyePGk.jpeg)

# nixos

Personal NixOS flake, one host, home-manager, several Wayland compositors, secrets via agenix.

## Quick start

```bash
nh os switch ~/nixos
just fmt      # nixfmt
just check    # nixfmt + statix + deadnix
```

Checkout expected at `~/nixos`.

## Layout

```
flake.nix                 inputs + nixosConfigurations.nixos
modules/lysec/            shared options (username, desktop, git, noctalia)
modules/nixos/            system modules (boot, greeter, networking, …)
hosts/nixos/              host entrypoint
hardware/                 hardware + storage mounts
desktops/<name>/          per-compositor nixos + home
home/                     shared HM (programs auto-imported, editors, shell)
secrets/                  encrypted .age files + recipients (secrets.nix)
lib/                      helpers (desktops, import-programs, fluxer)
```

## Settings (`lysec.*`)

All defaults live in [`modules/lysec/settings.nix`](modules/lysec/settings.nix). To switch compositors, set `lysec.desktop` there:

```nix
lysec.desktop = "niri";
```

| Option | Meaning |
| --- | --- |
| `lysec.desktop` | Active session: `niri` (default), `hyprland`, `sway`, `labwc`, `mango`, `plasma` |
| `lysec.git.*` | Commit identity + signing key |
| `lysec.username` / `hostname` / `stateVersion` / `system` | Host identity |

Only the chosen desktop’s `desktops/<name>/nixos.nix` is imported at build time.

## Desktops

Non-Plasma sessions use **greetd** + **Noctalia Greeter** ([`modules/nixos/greeter.nix`](modules/nixos/greeter.nix)). Plasma uses SDDM via [`desktops/plasma/nixos.nix`](desktops/plasma/nixos.nix).

| Desktop | Notes |
| --- | --- |
| **niri** | Full setup, keybinds, rules, animations, autostart |
| hyprland / sway / labwc / mango | Lighter stubs + Noctalia; mango has a custom session |
| plasma | KDE stack; Noctalia via XDG autostart after the panel |

Shared Wayland defaults (cursor, Electron/Qt hints): [`desktops/shared/home.nix`](desktops/shared/home.nix).

## Home

[`home/default.nix`](home/default.nix) pulls in the active desktop, Doom/VS Code, fish, and every `home/programs/*.nix` plus `home/programs/*/default.nix`.

Notable pieces: fish + tide, Firefox, Ghostty, Fluxer, Vesktop, signed git (GPG from agenix), Doom under `home/doom/`.

## Secrets (agenix)

Encrypted blobs in `secrets/*.age` decrypt at activation to `/run/agenix/`. Recipients are declared in [`secrets/secrets.nix`](secrets/secrets.nix) (host SSH pubkey + recovery age key).

```bash
cd ~/nixos/secrets
agenix -i ~/.config/age/keys.txt -e <name>.age
nh os switch ~/nixos
```

Do not commit `~/.config/age/keys.txt`. Back it up offline.

## Noctalia

Shell and greeter are `path:` inputs to local checkouts under `/mnt/storage/…`. This repo will not evaluate elsewhere without changing those inputs to the public flakes ([noctalia](https://github.com/noctalia-dev/noctalia), [noctalia-greeter](https://github.com/noctalia-dev/noctalia-greeter)).

After editing either checkout:

```bash
nix flake update noctalia noctalia-greeter
nh os switch ~/nixos
```

## Inputs

`nixpkgs` (unstable), `home-manager`, `niri`, `agenix`, `fluxer`, `waytator`, `doomemacs`, `nur`, plus the local Noctalia path inputs.

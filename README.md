![NixOS Configuration](https://i.imgur.com/4PyePGk.jpeg)

# NixOS configuration

Personal NixOS flake with home-manager. One host (`nixos`), multiple Wayland compositors, and shared home-manager modules for apps and shell tooling.

## Layout

```
.
├── flake.nix              # Flake inputs and nixosConfigurations.nixos
├── vars.nix               # Shared settings (username, desktop, paths, git)
├── vars.local.nix.example # Template for machine-local overrides (gitignored)
├── hosts/nixos/           # Host entry point
├── hardware/              # Machine hardware and storage
├── modules/nixos/         # System modules (boot, greeter, locale, services, …)
├── desktops/<name>/       # Per-compositor nixos.nix + home/ modules
├── home/                  # Shared home-manager config (programs, shell, editors)
└── lib/                   # Small helpers (desktops, fluxer wrapper)
```

The active compositor is selected in `vars.desktop`. Only that desktop's `desktops/<name>/nixos.nix` is imported at build time, so switching desktops does not pull every compositor into the closure.

Supported values: `niri`, `hyprland`, `sway`, `labwc`, `mango`, `plasma`.

## Configuration

Edit `vars.nix` for values you are happy to commit. For machine-specific overrides, copy `vars.local.nix.example` to `vars.local.nix` (gitignored):

```nix
{
  desktop = "hyprland";
}
```

If the checkout is not at `~/nixos`, set `NIXOS_CONFIG` to its path before rebuilding so `vars.local.nix` is found.

Important `vars` fields:

| Field | Purpose |
| --- | --- |
| `desktop` | Active compositor session |
| `git` | Git identity and signing key id |
| `gpgPrivateKey` | Path to a private key file imported on activation |
| `noctaliaI18nPushSecretFile` | Path to the i18n push token file (loaded into fish at login) |

## Noctalia

Noctalia Shell and the greeter use `path:` flake inputs to local dev checkouts — they will not work if you clone this repo. Use the [noctalia](https://github.com/noctalia-dev/noctalia) and [noctalia-greeter](https://github.com/noctalia-dev/noctalia-greeter) flakes instead.

After editing either checkout, update the lock before switching or Nix will rebuild from a stale snapshot:

```bash
nix flake update noctalia noctalia-greeter
nh os switch ~/nixos
```

## Desktop sessions

Non-Plasma desktops use **greetd** with **Noctalia Greeter**. Plasma uses its own display manager via `desktops/plasma/nixos.nix`.

Greeter settings are fully declared in `modules/nixos/greeter.nix` and installed to `/var/lib/noctalia-greeter/greeter.toml` on activation. Cursor theme uses `programs.noctalia-greeter.settings.cursor`.

**Niri** (default) has the most complete setup: keybinds, window rules, animations, autostart, and a `noctalia.kdl` include so Noctalia's Niri template is loaded from `~/.config/niri/noctalia.kdl`.

Other compositors (`hyprland`, `sway`, `labwc`, `mango`) ship stub home modules with Noctalia autostart and basic keybinds. `mango` also defines a custom greetd session.

Shared Wayland session defaults (Electron on X11, Qt on Wayland, cursor theme) live in `desktops/shared/home.nix`.

## Home manager

`home/default.nix` always imports shared desktop settings plus `desktops/<desktop>/home`, then program modules:

- **Shell:** fish (tide), microfetch greeting
- **Apps:** Firefox, Ghostty, Fluxer, Vesktop, Spicetify, VS Code, Doom Emacs
- **Git:** commit signing, GPG agent (pinentry-curses)

**Doom Emacs** lives in `home/doom/`, copied to `~/.config/doom` on activation

## Flake inputs

| Input | Use |
| --- | --- |
| `nixpkgs` | Base packages (unstable) |
| `home-manager` | User environment |
| `niri` | Niri compositor + HM module |
| `fluxer` | Fluxer Canary package |
| `spicetify-nix` | Spotify theming |
| `nur` | NUR overlay |
| `doomemacs` | Doom Emacs source (`flake = false`) |
| `waytator` | Screenshot annotator ([ItsLemmy/waytator](https://github.com/ItsLemmy/waytator)) |
| `noctalia` | Noctalia Shell (`path:` input) |
| `noctalia-greeter` | Login greeter (`path:` input) |

## Rebuild

```bash
sudo nixos-rebuild switch --flake .
```

Format:

```bash
nix fmt
```

## Notes

- **GPG signing** expects `gpgPrivateKey` to exist at activation time.
- **Fluxer** autostart is handled by the compositor (niri spawn-at-startup), not XDG autostart, to avoid a broken self-written desktop entry.

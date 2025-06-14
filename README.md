# Showcase

![Showcase Gif](https://i.imgur.com/alBK2pa.gif)

> ⚠️ **Important:** This repository includes my personal `hardware-configuration.nix`, which is specific to my hardware setup.  
> You **must replace it** with one generated for your system using `nixos-generate-config` to avoid compatibility issues.

# NixOS Configuration

This repository contains my personal NixOS configuration for a customized desktop and development environment. 🎨💻

## Directory Structure

- **`assets/`** 🎨  
  Contains custom icons and wallpapers.

  - **`icons/`**: Custom icon set.
  - **`wallpapers/`**: Collection of wallpapers.

- **`dev-shells/`** 🧑‍💻  
  Development environments.

- **`hosts/`** 🖥️  
  Host-specific configurations.

  - **`default/`**: Default host configuration including `hardware-configuration.nix`, `home.nix`, and `packages.nix`.

- **`modules/`** ⚙️  
  Custom NixOS modules for desktop, editors, programs, and more.

  - **`desktop/`**: Configuration for Hyprland, Waybar, and related tools.
  - **`editors/`**: Neovim and VSCode configurations.
  - **`programs/`**: Additional program configurations (e.g., Fastfetch, Ghostty).
  - **`quickshell/`**: The current quickshell setup, thanks to [Rexcrazy804](https://github.com/Rexcrazy804) for helping me quite a bit!

- **`system/`** 🔧  
  System-wide configurations.
  - **`environment.nix`**: Global environment settings.
  - **`greeter/`**: Greetd configuration for login.
  - **`shell/`**: Shell configurations for Bash and Fish.
  - **`xdg.nix`**: XDG settings.

## Getting Started

Clone this repository and adjust the configurations based on your system. Modify the host-specific files and modules to suit your needs.

Feel free to customize and contribute!

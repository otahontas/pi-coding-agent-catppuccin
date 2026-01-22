# Pi coding agent - Catppuccin themes

[Catppuccin](https://catppuccin.com/) themes for the [Pi coding agent](https://github.com/badlogic/pi-mono):

- 🌻 **Latte** (Light theme)
- 🪴 **Frappé** (Dark theme)
- 🌺 **Macchiato** (Dark theme)
- 🌿 **Mocha** (Dark theme)

## Installation

### Nix

Add as a flake input and enable in Home Manager:

```nix
programs.pi.catppuccin.enable = true;
```

Automatically follows `catppuccin.flavor` from [catppuccin/nix](https://github.com/catppuccin/nix) if enabled. Otherwise set flavor explicitly:

```nix
programs.pi.catppuccin.flavor = "macchiato";  # latte, frappe, macchiato, or mocha
```

The theme is automatically installed and activated in Pi's settings.

### Manual Installation

1. Clone the repo and copy the theme files to your Pi themes directory:

   ```bash
   git clone https://github.com/otahontas/pi-coding-agent-catppuccin.git /tmp/pi-catppuccin && \
   cp /tmp/pi-catppuccin/catppuccin-*.json ~/.pi/agent/themes/
   ```

2. Select a theme in Pi:
   - Run `pi` to start the coding agent
   - Type `/settings` to open the settings menu
   - Select the theme option and choose `catppuccin-mocha` (or latte/frappe/macchiato)

## Design notes

Follows official Catppuccin colors, except tool success/error backgrounds use the convention from [catppuccin/delta](https://github.com/catppuccin/delta/blob/main/catppuccin.gitconfig) (subtle 20% color mixes)

## License

Catppuccin is released under the MIT License. See [catppuccin/catppuccin](https://github.com/catppuccin/catppuccin) for details.

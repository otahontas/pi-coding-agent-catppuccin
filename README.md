# Pi coding agent - Catppuccin themes

[Catppuccin](https://catppuccin.com/) themes for the [Pi coding agent](https://github.com/badlogic/pi-mono):

- 🌻 **Latte** (Light theme)
- 🪴 **Frappé** (Dark theme)
- 🌺 **Macchiato** (Dark theme)
- 🌿 **Mocha** (Dark theme)

## Installation

### Pi package manager

```bash
pi install git:github.com/otahontas/pi-coding-agent-catppuccin
```

Then select a theme in Pi via `/settings`.

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

### Manual

1. Clone the repo and copy theme files to your Pi themes directory:

   ```bash
   git clone https://github.com/otahontas/pi-coding-agent-catppuccin.git /tmp/pi-catppuccin && \
   cp /tmp/pi-catppuccin/catppuccin-*.json ~/.pi/agent/themes/
   ```

2. Select a theme in Pi via `/settings`.

## Design notes

Follows official Catppuccin colors, except tool success/error backgrounds use the convention from [catppuccin/delta](https://github.com/catppuccin/delta/blob/main/catppuccin.gitconfig) (subtle 20% color mixes)

## License

Catppuccin is released under the MIT License. See [catppuccin/catppuccin](https://github.com/catppuccin/catppuccin) for details.

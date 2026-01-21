[private]
default:
    @echo "No default recipe. Run 'just --list' to see available recipes."
    @exit 1

format *args:
    treefmt -v {{ args }}

verify-colors:
    python3 verify-catppuccin-colors.py

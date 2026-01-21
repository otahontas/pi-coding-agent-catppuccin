#!/usr/bin/env python3
"""
Catppuccin Theme Color Verification Script

This script verifies that Catppuccin theme files match the official color
specifications from https://catppuccin.com/palette/

Usage:
    python3 verify-catppuccin-colors.py

Requirements:
    - Python 3
    - Internet connection (to fetch official palette)
"""

import json
import sys
import urllib.request
from pathlib import Path

OFFICIAL_PALETTE_URL = "https://raw.githubusercontent.com/catppuccin/palette/main/palette.json"
FLAVORS = ['latte', 'frappe', 'macchiato', 'mocha']


def fetch_official_palette():
    """Fetch the official Catppuccin palette from GitHub."""
    try:
        with urllib.request.urlopen(OFFICIAL_PALETTE_URL) as response:
            return json.loads(response.read().decode())
    except Exception as e:
        print(f"❌ Error fetching official palette: {e}")
        sys.exit(1)


def load_theme_file(flavor):
    """Load a theme file from the current directory."""
    theme_path = Path(f"catppuccin-{flavor}.json")
    if not theme_path.exists():
        return None
    
    try:
        with open(theme_path) as f:
            return json.load(f)
    except Exception as e:
        print(f"❌ Error loading {theme_path}: {e}")
        return None


def verify_colors(flavor, official_colors, theme_vars):
    """Verify that theme colors match official specifications."""
    mismatches = []
    
    for color_name, color_data in official_colors.items():
        official_hex = color_data['hex']
        theme_hex = theme_vars.get(color_name, 'MISSING')
        
        if theme_hex == 'MISSING':
            mismatches.append({
                'color': color_name,
                'theme': 'MISSING',
                'official': official_hex,
                'type': 'missing'
            })
        elif theme_hex.lower() != official_hex.lower():
            mismatches.append({
                'color': color_name,
                'theme': theme_hex,
                'official': official_hex,
                'type': 'mismatch'
            })
    
    return mismatches


def print_header():
    """Print the report header."""
    print("=" * 80)
    print("CATPPUCCIN THEME COLOR VERIFICATION")
    print("=" * 80)
    print()
    print("Source: https://catppuccin.com/palette/")
    print("Official Palette: https://github.com/catppuccin/palette")
    print()
    print("=" * 80)


def print_flavor_report(flavor, official, theme, mismatches):
    """Print verification report for a single flavor."""
    emoji = official[flavor]['emoji']
    name = official[flavor]['name']
    theme_type = 'Dark' if official[flavor]['dark'] else 'Light'
    color_count = len(official[flavor]['colors'])
    
    print(f"\n📦 {flavor.upper()} ({emoji} {name})")
    print(f"   Type: {theme_type} theme")
    print("-" * 80)
    
    if theme is None:
        print("   Status: ⚠️  SKIPPED - Theme file not found")
        return False
    
    print(f"   Colors verified: {color_count}")
    
    if mismatches:
        print(f"   Status: ❌ FAILED - {len(mismatches)} issue(s) found")
        for issue in mismatches:
            if issue['type'] == 'missing':
                print(f"      • {issue['color']}: MISSING in theme file")
            else:
                print(f"      • {issue['color']}: {issue['theme']} → should be {issue['official']}")
        return False
    else:
        print("   Status: ✅ PASSED - All colors correct")
        return True


def print_sample_colors(official, themes):
    """Print a sample of colors from each flavor."""
    print("\n" + "=" * 80)
    print("📋 SAMPLE COLOR VERIFICATION (showing 10 colors from each flavor)")
    print("=" * 80)
    
    sample_colors = ['rosewater', 'pink', 'mauve', 'red', 'peach', 
                     'green', 'blue', 'text', 'base', 'crust']
    
    for flavor in FLAVORS:
        if themes[flavor] is None:
            continue
            
        print(f"\n{flavor.upper()}: {official[flavor]['emoji']}")
        for color in sample_colors:
            official_hex = official[flavor]['colors'][color]['hex']
            theme_hex = themes[flavor]['vars'].get(color, 'MISSING')
            match = "✓" if official_hex.lower() == theme_hex.lower() else "✗"
            print(f"  {match} {color:12} {theme_hex:8} (official: {official_hex})")


def main():
    """Main verification function."""
    print_header()
    
    # Fetch official palette
    print("Fetching official Catppuccin palette...\n")
    official = fetch_official_palette()
    
    # Load all theme files
    themes = {}
    for flavor in FLAVORS:
        themes[flavor] = load_theme_file(flavor)
    
    # Verify each flavor
    all_passed = True
    for flavor in FLAVORS:
        theme = themes[flavor]
        if theme is None:
            all_passed = False
            print_flavor_report(flavor, official, None, [])
            continue
        
        mismatches = verify_colors(flavor, official[flavor]['colors'], theme['vars'])
        passed = print_flavor_report(flavor, official, theme, mismatches)
        all_passed = all_passed and passed
    
    # Print sample colors
    if any(t is not None for t in themes.values()):
        print_sample_colors(official, themes)
    
    # Print final summary
    print("\n" + "=" * 80)
    if all_passed:
        print("✅ VERIFICATION COMPLETE: All themes match official specifications!")
        print("=" * 80)
        sys.exit(0)
    else:
        print("❌ VERIFICATION FAILED: Some themes have issues")
        print("=" * 80)
        sys.exit(1)


if __name__ == "__main__":
    main()

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a tmux plugin that provides a floating fzf interface for quick window switching with intelligent prefix matching and visual indicators. The plugin consists of:

- `tmux_quick_switch.tmux` - Main plugin entry point that configures key bindings
- `scripts/quick-switch.sh` - Core functionality implementing the fzf popup interface

## Architecture

The plugin follows a two-stage execution model:
1. Initial tmux command execution checks for fzf and spawns a popup
2. Popup execution (`$1 == "popup"`) runs the fzf interface with window selection logic

Key functions in `scripts/quick-switch.sh`:
- `get_window_list_with_colored_prefixes()` - Calculates minimum unique prefixes and applies ANSI coloring (lines 15-77)
- `show_fzf_popup()` - Main fzf interface with optional auto-jump functionality (lines 79-139)

## Configuration Options

The plugin reads tmux options:
- `@quick_switch_key` - Custom key binding (default: "prefix" for prefix-prefix)
- `@quick_switch_auto_jump_exact` - Enable auto-jump for exact prefix matches (default: "off")

## Dependencies

- fzf must be installed and available in PATH
- tmux version 3.2+ for popup support

## Testing

No automated test suite is present. Manual testing involves:
1. Installing the plugin in a tmux session
2. Creating multiple windows with different names
3. Testing the key binding to open the switcher
4. Verifying prefix highlighting and auto-jump functionality

## Development Notes

- ANSI escape sequences are used for coloring: `\033[1;91m` (light red, bold) and `\033[0m` (reset)
- The plugin handles ANSI code stripping for text matching operations
- Window mapping uses format: "window_name (active):window_index"
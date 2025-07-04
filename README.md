# tmux_quick_switch

A tmux plugin that provides a floating fzf interface for quick window switching
with intelligent prefix matching and visual indicators.

## Installation

### Via TPM (Tmux Plugin Manager)

Add this line to your `~/.tmux.conf`:

```bash
set -g @plugin 'samuelstranges/tmux_quick_switch'
```

Then press `prefix + I` to install.

### Manual Installation

1. Clone this repository:

    ```bash
    git clone https://github.com/samuelstranges/tmux_quick_switch.git ~/.tmux/plugins/tmux_quick_switch
    ```

2. Add this line to your `~/.tmux.conf`:

    ```bash
    run-shell ~/.tmux/plugins/tmux_quick_switch/tmux_quick_switch.tmux
    ```

3. Reload tmux configuration:
    ```bash
    tmux source-file ~/.tmux.conf
    ```

## Usage

- Press your tmux prefix key twice (default: `Ctrl-b Ctrl-b`) to open the window
  switcher
- Use arrow keys to navigate through your windows
- Press `Enter` to select a window
- Press `Esc` to cancel

## Configuration

### Key Binding

You can customize the key binding by setting the `@quick_switch_key` option in
your `~/.tmux.conf`:

```bash
# Use a custom key binding instead of prefix-prefix
set -g @quick_switch_key 'C-w'
```

### Auto-Jump Exact Match

Enable automatic jumping when typing an exact prefix match:

```bash
# Enable auto-jump for exact prefix matches
set -g @quick_switch_auto_jump_exact 'on'
```

## Requirements

- [fzf](https://github.com/junegunn/fzf) must be installed and available in your
  PATH
- tmux version 3.2 or later (for popup support)

## Features

- **Centered floating popup window**
- **Intelligent prefix highlighting** - Minimum unique prefixes are highlighted
  in red and bold
- **Visual active window indicator** - Shows which window is currently active
- **Auto-jump exact matching** - Automatically switch to windows when typing
  exact prefixes (when enabled)
- **Configurable key binding** - Use custom key combinations or stick with
  prefix-prefix
- **Automatic fzf detection** - Graceful error handling if fzf is not installed
- **ANSI color support** - Beautiful colored output in the fzf interface

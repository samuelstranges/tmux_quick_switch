# tmux-quick-switch

A tmux plugin that provides a floating fzf interface for quick window switching using prefix-prefix key binding.

## Installation

### Via TPM (Tmux Plugin Manager)

Add this line to your `~/.tmux.conf`:

```bash
set -g @plugin 'your-username/tmux-quick-switch'
```

Then press `prefix + I` to install.

### Manual Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/tmux-quick-switch.git ~/.tmux/plugins/tmux-quick-switch
   ```

2. Add this line to your `~/.tmux.conf`:
   ```bash
   run-shell ~/.tmux/plugins/tmux-quick-switch/tmux-quick-switch.tmux
   ```

3. Reload tmux configuration:
   ```bash
   tmux source-file ~/.tmux.conf
   ```

## Usage

- Press your tmux prefix key twice (default: `Ctrl-b Ctrl-b`) to open the window switcher
- Use arrow keys to navigate through your windows
- Press `Enter` to select a window
- Press `Esc` to cancel

## Configuration

You can customize the key binding by setting the `@quick_switch_key` option in your `~/.tmux.conf`:

```bash
# Use a custom key binding instead of prefix-prefix
set -g @quick_switch_key 'C-w'
```

## Requirements

- [fzf](https://github.com/junegunn/fzf) must be installed and available in your PATH
- tmux version 3.2 or later (for popup support)

## Features

- Centered floating popup window
- Shows window index, name, and active status
- Keyboard navigation with fzf
- Configurable key binding
- Automatic fzf detection with error message if not installed
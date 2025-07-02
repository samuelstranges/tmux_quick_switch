#!/usr/bin/env bash

get_window_list() {
    tmux list-windows -F "#{window_index}: #{window_name} #{?window_active,(active),}"
}

show_fzf_popup() {
    local selected_window
    
    selected_window=$(get_window_list | fzf \
        --height=50% \
        --reverse \
        --border \
        --prompt="Select window: " \
        --header="Use arrow keys to navigate, Enter to select, Esc to cancel" \
        --preview-window=hidden)
    
    if [[ -n "$selected_window" ]]; then
        local window_index
        window_index=$(echo "$selected_window" | cut -d: -f1)
        tmux select-window -t "$window_index"
    fi
}

if command -v fzf >/dev/null 2>&1; then
    tmux display-popup -E -h 50% -w 80% -x C -y C "bash $0 popup"
else
    tmux display-message "fzf is not installed"
fi

if [[ "$1" == "popup" ]]; then
    show_fzf_popup
fi
#!/usr/bin/env bash

get_window_list() {
    tmux list-windows -F "#{window_index}: #{window_name} #{?window_active,(active),}"
}

get_window_list_for_display() {
    tmux list-windows -F "#{window_name} #{?window_active,(active),}"
}

get_window_mapping() {
    tmux list-windows -F "#{window_name} #{?window_active,(active),}:#{window_index}"
}

show_fzf_popup() {
    local selected_window
    local auto_jump_exact="$1"
    
    # Check for exact prefix match if auto jump is enabled
    if [[ "$auto_jump_exact" == "on" ]]; then
        local window_display_list=$(get_window_list_for_display)
        local window_mapping=$(get_window_mapping)
        
        # Use fzf with display list (no numbers) but bind to mapping for selection
        selected_window=$(echo "$window_display_list" | fzf \
            --height=50% \
            --reverse \
            --border \
            --prompt="Select window (^prefix for exact match): " \
            --header="Use arrow keys to navigate, Enter to select, Esc to cancel, ^prefix for exact match" \
            --preview-window=hidden \
            --bind="change:execute-silent(
                query={q}
                if [[ \$query =~ ^\^.+ ]]; then
                    prefix=\${query#^}
                    matches=\$(echo '$window_display_list' | grep -E \"^\$prefix\" | wc -l)
                    if [[ \$matches -eq 1 ]]; then
                        match=\$(echo '$window_display_list' | grep -E \"^\$prefix\" | head -1)
                        window_index=\$(echo '$window_mapping' | grep -F \"\$match\" | head -1 | cut -d: -f2)
                        tmux select-window -t \"\$window_index\" 2>/dev/null || true
                        tmux display-popup -C
                    fi
                fi
            )")
        
        if [[ -n "$selected_window" ]]; then
            local window_index
            window_index=$(echo "$window_mapping" | grep -F "$selected_window" | head -1 | cut -d: -f2)
            tmux select-window -t "$window_index"
        fi
    else
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
    fi
}

if command -v fzf >/dev/null 2>&1; then
    tmux display-popup -E -h 50% -w 80% -x C -y C "bash $0 popup $1"
else
    tmux display-message "fzf is not installed"
fi

if [[ "$1" == "popup" ]]; then
    show_fzf_popup "$2"
fi
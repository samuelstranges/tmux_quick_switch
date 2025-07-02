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

get_window_list_with_colored_prefixes() {
    local window_data=($(tmux list-windows -F "#{window_name}|#{?window_active,1,0}"))
    local window_names=()
    local active_flags=()
    local result=""
    
    # Parse window data to separate names and active status
    for entry in "${window_data[@]}"; do
        local name="${entry%|*}"
        local active="${entry#*|}"
        window_names+=("$name")
        active_flags+=("$active")
    done
    
    # For each window, calculate minimum unique prefix
    for i in "${!window_names[@]}"; do
        local current_name="${window_names[$i]}"
        local is_active="${active_flags[$i]}"
        local min_prefix_len=1
        local unique_prefix=""
        
        # Find minimum unique prefix
        while [[ $min_prefix_len -le ${#current_name} ]]; do
            local prefix="${current_name:0:$min_prefix_len}"
            local matches=0
            
            # Count how many windows start with this prefix
            for other_name in "${window_names[@]}"; do
                if [[ "$other_name" == "$prefix"* ]]; then
                    ((matches++))
                fi
            done
            
            if [[ $matches -eq 1 ]]; then
                unique_prefix="$prefix"
                break
            fi
            ((min_prefix_len++))
        done
        
        # If no unique prefix found, use full name
        if [[ -z "$unique_prefix" ]]; then
            unique_prefix="$current_name"
        fi
        
        # Color the unique prefix light red and bold, rest normal
        local colored_name=""
        if [[ ${#unique_prefix} -lt ${#current_name} ]]; then
            colored_name="\033[1;91m${unique_prefix}\033[0m${current_name:${#unique_prefix}}"
        else
            colored_name="\033[1;91m${current_name}\033[0m"
        fi
        
        # Add active status if present
        if [[ "$is_active" == "1" ]]; then
            result+="${colored_name} (active)"$'\n'
        else
            result+="${colored_name}"$'\n'
        fi
    done
    
    echo -e "$result"
}

show_fzf_popup() {
    local selected_window
    local auto_jump_exact="$1"
    
    # Check for exact prefix match if auto jump is enabled
    if [[ "$auto_jump_exact" == "on" ]]; then
        local window_display_list=$(get_window_list_with_colored_prefixes)
        local window_mapping=$(get_window_mapping)
        
        # Use fzf with colored display list and enable ANSI colors
        selected_window=$(echo "$window_display_list" | fzf \
            --height=50% \
            --reverse \
            --border \
            --ansi \
            --prompt="Select window: " \
            --header="Use arrow keys to navigate, Enter to select, Esc to cancel" \
            --preview-window=hidden \
            --bind="change:execute-silent(
                query={q}
                if [[ \$query =~ ^\^.+ ]]; then
                    prefix=\${query#^}
                    # Strip ANSI codes for matching
                    plain_display=\$(echo '$window_display_list' | sed 's/\x1b\[[0-9;]*m//g')
                    matches=\$(echo \"\$plain_display\" | grep -E \"^\$prefix\" | wc -l)
                    if [[ \$matches -eq 1 ]]; then
                        match=\$(echo \"\$plain_display\" | grep -E \"^\$prefix\" | head -1)
                        # Remove (active) from match for proper mapping lookup
                        clean_match=\$(echo \"\$match\" | sed 's/ (active)$//')
                        window_index=\$(echo '$window_mapping' | grep -F \"\$clean_match\" | head -1 | cut -d: -f2)
                        tmux select-window -t \"\$window_index\" 2>/dev/null || true
                        tmux display-popup -C
                    fi
                fi
            )")
        
        if [[ -n "$selected_window" ]]; then
            # Strip ANSI codes from selected window for matching
            local plain_selected=$(echo "$selected_window" | sed 's/\x1b\[[0-9;]*m//g')
            # Remove (active) from selection for proper mapping lookup
            local clean_selected=$(echo "$plain_selected" | sed 's/ (active)$//')
            local window_index
            window_index=$(echo "$window_mapping" | grep -F "$clean_selected" | head -1 | cut -d: -f2)
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
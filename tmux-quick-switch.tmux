#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

get_tmux_option() {
    local option=$1
    local default_value=$2
    local option_value=$(tmux show-option -gqv "$option")
    if [[ -z "$option_value" ]]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}

quick_switch_key=$(get_tmux_option "@quick_switch_key" "prefix")

if [[ "$quick_switch_key" == "prefix" ]]; then
    prefix_key=$(tmux show-options -g prefix | cut -d' ' -f2)
    tmux bind-key "$prefix_key" run-shell "$CURRENT_DIR/scripts/quick-switch.sh"
    
    # Also bind to secondary prefix if it exists
    prefix2_key=$(tmux show-options -g prefix2 2>/dev/null | cut -d' ' -f2)
    if [[ -n "$prefix2_key" ]]; then
        tmux bind-key "$prefix2_key" run-shell "$CURRENT_DIR/scripts/quick-switch.sh"
    fi
else
    tmux bind-key -T root "$quick_switch_key" run-shell "$CURRENT_DIR/scripts/quick-switch.sh"
fi
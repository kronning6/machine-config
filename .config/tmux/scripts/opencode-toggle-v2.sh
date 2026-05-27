#!/bin/bash

CURRENT_PATH=$(tmux display-message -p -F "#{pane_current_path}")
CURRENT_SESSION=$(tmux display-message -p -F "#{session_name}")
CURRENT_WINDOW_ID=$(tmux display-message -p -F "#{window_id}")

OPENCODE_WINDOW="opencode"
OPENCODE_WINDOW_MARKER="@opencode_storage_window"
OPENCODE_PROFILE_OVERRIDES="$HOME/.config/tmux/opencode-profiles.local"

opencode_xdg_data_home() {
    local session_pattern
    local xdg_data_home

    if [[ ! -f "$OPENCODE_PROFILE_OVERRIDES" ]]; then
        return
    fi

    while read -r session_pattern xdg_data_home; do
        if [[ -z "$session_pattern" || "$session_pattern" == \#* || -z "$xdg_data_home" ]]; then
            continue
        fi

        if [[ "$CURRENT_SESSION" == $session_pattern ]]; then
            if [[ "$xdg_data_home" == "~/"* ]]; then
                printf "%s/%s" "$HOME" "${xdg_data_home#\~/}"
            else
                printf "%s" "$xdg_data_home"
            fi
            return
        fi
    done < "$OPENCODE_PROFILE_OVERRIDES"
}

opencode_window_id() {
    local window_id
    local pane_count

    window_id=$(tmux list-windows -t "$CURRENT_SESSION" -F "#{window_id} #{${OPENCODE_WINDOW_MARKER}}" | awk '$2 == "1" { print $1; exit }')
    if [[ -n "$window_id" ]]; then
        printf "%s" "$window_id"
        return
    fi

    window_id=$(tmux list-windows -t "$CURRENT_SESSION" -F "#{window_id} #{window_name}" | awk -v name="$OPENCODE_WINDOW" -v current="$CURRENT_WINDOW_ID" '$2 == name && $1 != current { print $1; exit }')
    if [[ -n "$window_id" ]]; then
        printf "%s" "$window_id"
        return
    fi

    window_id=$(tmux list-windows -t "$CURRENT_SESSION" -F "#{window_id} #{window_name}" | awk -v name="$OPENCODE_WINDOW" -v current="$CURRENT_WINDOW_ID" '$2 == name && $1 == current { print $1; exit }')
    if [[ -n "$window_id" ]]; then
        pane_count=$(tmux list-panes -t "$window_id" -F "#{pane_id}" | wc -l | tr -d ' ')
        if [[ "$pane_count" == "1" ]]; then
            printf "%s" "$window_id"
        fi
    fi
}

ensure_opencode_window() {
    local window_id

    window_id=$(opencode_window_id)
    if [[ -n "$window_id" ]]; then
        tmux set-option -w -t "$window_id" -q "$OPENCODE_WINDOW_MARKER" 1
        printf "%s" "$window_id"
        return
    fi

    tmux new-window -d -t "$CURRENT_SESSION" -n "$OPENCODE_WINDOW" -c "$CURRENT_PATH"
    window_id=$(opencode_window_id)
    tmux set-option -w -t "$window_id" -q "$OPENCODE_WINDOW_MARKER" 1
    printf "%s" "$window_id"
}

find_opencode_pane() {
    tmux list-panes -s -t "$CURRENT_SESSION" -F "#{window_id} #{pane_id} #{pane_current_command}" | awk '$3 == "opencode" { print $1 " " $2; exit }'
}

select_moved_pane() {
    tmux select-pane -t "$1"
}

move_pane_to_current_window() {
    local pane_id="$1"
    local placeholder_pane_id
    local source_window_id

    source_window_id=$(tmux display-message -p -t "$pane_id" -F "#{window_id}")
    placeholder_pane_id=$(tmux split-window -d -P -F "#{pane_id}" -t "$CURRENT_WINDOW_ID" -h -c "$CURRENT_PATH")
    tmux swap-pane -s "$pane_id" -t "$placeholder_pane_id"

    if [[ "$source_window_id" != "$OPENCODE_WINDOW_ID" ]]; then
        tmux kill-pane -t "$placeholder_pane_id"
    else
        make_opencode_placeholder_only_pane "$OPENCODE_WINDOW_ID"
    fi

    select_moved_pane "$pane_id"
}

move_pane_to_opencode_window() {
    local pane_id="$1"
    local opencode_window_id="$2"
    local placeholder_pane_id

    placeholder_pane_id=$(tmux list-panes -t "$opencode_window_id" -F "#{pane_id}" | awk -v pane="$pane_id" '$1 != pane { print $1; exit }')
    if [[ -z "$placeholder_pane_id" ]]; then
        placeholder_pane_id=$(tmux split-window -d -P -F "#{pane_id}" -t "$opencode_window_id" -h -c "$CURRENT_PATH")
    fi

    tmux swap-pane -s "$pane_id" -t "$placeholder_pane_id"
    tmux kill-pane -t "$placeholder_pane_id"
}

make_opencode_only_pane() {
    local pane_id="$1"
    local opencode_window_id="$2"
    local select_pane="${3:-false}"

    while read -r other_pane_id; do
        if [[ -n "$other_pane_id" && "$other_pane_id" != "$pane_id" ]]; then
            tmux kill-pane -t "$other_pane_id"
        fi
    done < <(tmux list-panes -t "$opencode_window_id" -F "#{pane_id}")

    if [[ "$select_pane" == "true" ]]; then
        tmux select-pane -t "$pane_id"
    fi
}

make_opencode_placeholder_only_pane() {
    local opencode_window_id="$1"
    local keep_pane_id=""

    while read -r pane_id pane_command; do
        if [[ "$pane_command" == "opencode" ]]; then
            return
        fi

        if [[ -z "$keep_pane_id" ]]; then
            keep_pane_id="$pane_id"
        elif [[ -n "$pane_id" ]]; then
            tmux kill-pane -t "$pane_id"
        fi
    done < <(tmux list-panes -t "$opencode_window_id" -F "#{pane_id} #{pane_current_command}")
}

zoom_pane() {
    local pane_id="$1"

    if [[ "$(tmux display-message -p -t "$pane_id" -F "#{window_zoomed_flag}")" == "0" ]]; then
        tmux resize-pane -Z -t "$pane_id"
    fi
}

create_opencode_pane_in_window() {
    local opencode_window_id="$1"
    local xdg_data_home

    xdg_data_home=$(opencode_xdg_data_home)
    if [[ -n "$xdg_data_home" ]]; then
        tmux split-window -P -F "#{pane_id}" -t "$opencode_window_id" -h -c "$CURRENT_PATH" -e "XDG_DATA_HOME=$xdg_data_home" 'opencode "$PWD"'
    else
        tmux split-window -P -F "#{pane_id}" -t "$opencode_window_id" -h -c "$CURRENT_PATH" 'opencode "$PWD"'
    fi
}

OPENCODE_WINDOW_ID=$(ensure_opencode_window)
OPENCODE_PANE_INFO=$(find_opencode_pane)
OPENCODE_PANE_WINDOW_ID=$(printf "%s" "$OPENCODE_PANE_INFO" | awk '{ print $1 }')
OPENCODE_PANE_ID=$(printf "%s" "$OPENCODE_PANE_INFO" | awk '{ print $2 }')

if [[ "$CURRENT_WINDOW_ID" == "$OPENCODE_WINDOW_ID" ]]; then
    if [[ -z "$OPENCODE_PANE_ID" ]]; then
        OPENCODE_PANE_ID=$(create_opencode_pane_in_window "$OPENCODE_WINDOW_ID")
    elif [[ "$OPENCODE_PANE_WINDOW_ID" != "$OPENCODE_WINDOW_ID" ]]; then
        move_pane_to_opencode_window "$OPENCODE_PANE_ID" "$OPENCODE_WINDOW_ID"
    fi

    make_opencode_only_pane "$OPENCODE_PANE_ID" "$OPENCODE_WINDOW_ID" true
    zoom_pane "$OPENCODE_PANE_ID"
    exit 0
fi

if [[ -n "$OPENCODE_PANE_ID" && "$OPENCODE_PANE_WINDOW_ID" == "$CURRENT_WINDOW_ID" ]]; then
    move_pane_to_opencode_window "$OPENCODE_PANE_ID" "$OPENCODE_WINDOW_ID"
    make_opencode_only_pane "$OPENCODE_PANE_ID" "$OPENCODE_WINDOW_ID"
    zoom_pane "$OPENCODE_PANE_ID"
    tmux select-window -t "$CURRENT_WINDOW_ID"
elif [[ -n "$OPENCODE_PANE_ID" ]]; then
    move_pane_to_current_window "$OPENCODE_PANE_ID"
else
    OPENCODE_PANE_ID=$(create_opencode_pane_in_window "$OPENCODE_WINDOW_ID")
    move_pane_to_current_window "$OPENCODE_PANE_ID"
fi

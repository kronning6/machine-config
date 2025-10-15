#!/bin/bash

CURRENT_PATH=$(tmux display-message -p -F "#{pane_current_path}")
if [[ "$CURRENT_PATH" =~ ^.*/code/([^/]+) ]]; then
    PROJECT_NAME="${BASH_REMATCH[1]}"
else
    PROJECT_NAME=$(basename "$CURRENT_PATH")
fi

OPENCODE_SESSION="opencode"
OPENCODE_WINDOW="$PROJECT_NAME"
OPENCODE_PANE_TITLE="opencode-$PROJECT_NAME"

# Ensure the opencode session exists
if ! tmux has-session -t "$OPENCODE_SESSION" 2>/dev/null; then
    tmux new-session -d -s "$OPENCODE_SESSION" -n "$OPENCODE_WINDOW"
else
    # Ensure project-specific window exists in opencode session
    if ! tmux list-windows -t "$OPENCODE_SESSION" -F "#{window_name}" | grep -q "^$OPENCODE_WINDOW$"; then
        tmux new-window -t "$OPENCODE_SESSION" -n "$OPENCODE_WINDOW"
    fi
fi

CURRENT_SESSION=$(tmux display-message -p -F "#{session_name}")
CURRENT_WINDOW=$(tmux display-message -p -F "#{window_index}")

# Exit if we're in the opencode tmux session
if [[ "$CURRENT_SESSION" == "$OPENCODE_SESSION" ]]; then
    exit 0
fi

# Check if the opencode pane exists anywhere in the current session
EXISTING_PANE_INFO=$(tmux list-panes -s -t "$CURRENT_SESSION" -F "#{window_index} #{pane_index} #{pane_title}" | grep "$OPENCODE_PANE_TITLE")

# Parse the pane location
EXISTING_PANE_IN_CURRENT=""
EXISTING_PANE_IN_OTHER_WINDOW=""
PANE_SOURCE_WINDOW=""

if [[ -n "$EXISTING_PANE_INFO" ]]; then
    PANE_WINDOW=$(echo "$EXISTING_PANE_INFO" | cut -d' ' -f1)
    PANE_INDEX=$(echo "$EXISTING_PANE_INFO" | cut -d' ' -f2)
    if [[ "$PANE_WINDOW" == "$CURRENT_WINDOW" ]]; then
        EXISTING_PANE_IN_CURRENT="$PANE_INDEX"
    else
        EXISTING_PANE_IN_OTHER_WINDOW="$PANE_INDEX"
        PANE_SOURCE_WINDOW="$PANE_WINDOW"
    fi
fi

# Check if the opencode pane exists in the opencode session window
EXISTING_PANE_IN_STORAGE=$(tmux list-panes -t "$OPENCODE_SESSION:$OPENCODE_WINDOW" -F "#{pane_index} #{pane_title}" | grep "$OPENCODE_PANE_TITLE" | cut -d' ' -f1)


if [[ -n "$EXISTING_PANE_IN_CURRENT" ]]; then
    # Move the pane back to opencode session (specific project window)
    tmux move-pane -s "$CURRENT_SESSION:$CURRENT_WINDOW.$EXISTING_PANE_IN_CURRENT" -t "$OPENCODE_SESSION:$OPENCODE_WINDOW" -h
elif [[ -n "$EXISTING_PANE_IN_OTHER_WINDOW" ]]; then
    # Move the pane from another window in current session to current window
    tmux move-pane -s "$CURRENT_SESSION:$PANE_SOURCE_WINDOW.$EXISTING_PANE_IN_OTHER_WINDOW" -t "$CURRENT_SESSION:$CURRENT_WINDOW" -h
    # Get the pane index after the move and select it
    FINAL_PANE=$(tmux display-message -p -F "#{pane_index}")
    tmux select-pane -t "$CURRENT_SESSION:$CURRENT_WINDOW.$FINAL_PANE" -T "$OPENCODE_PANE_TITLE"
elif [[ -n "$EXISTING_PANE_IN_STORAGE" ]]; then
    # Bring the pane from opencode storage to current window (right split)
    tmux move-pane -s "$OPENCODE_SESSION:$OPENCODE_WINDOW.$EXISTING_PANE_IN_STORAGE" -t "$CURRENT_SESSION:$CURRENT_WINDOW" -h
    # Get the pane index after the move and select it
    FINAL_PANE=$(tmux display-message -p -F "#{pane_index}")
    tmux select-pane -t "$CURRENT_SESSION:$CURRENT_WINDOW.$FINAL_PANE" -T "$OPENCODE_PANE_TITLE"
else
    # Create a new opencode pane in current window (right split)
    tmux split-window -t "$CURRENT_SESSION:$CURRENT_WINDOW" -h -c "$CURRENT_PATH" "opencode '$CURRENT_PATH'"
    # Get the pane index after creation and select it
    FINAL_PANE=$(tmux display-message -p -F "#{pane_index}")
    tmux select-pane -t "$CURRENT_SESSION:$CURRENT_WINDOW.$FINAL_PANE" -T "$OPENCODE_PANE_TITLE"
fi


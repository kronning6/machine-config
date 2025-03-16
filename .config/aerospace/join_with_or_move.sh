#!/usr/bin/env bash

# This script attempts to join windows in a given direction.
# If the join-with command doesn't succeed (returns a nonzero exit status),
# it falls back to moving in that direction.
#
# Usage: ./join_move.sh <direction>
# Example: ./join_move.sh left

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <direction>" >&2
    exit 1
fi

direction="$1"

# Attempt to join; if join-with doesn't work, then move.
aerospace join-with "$direction" || aerospace move "$direction"

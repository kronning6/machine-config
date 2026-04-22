#!/bin/bash
# ~/.local/bin/worktree-add
set -e

MAIN_DIR="$(git rev-parse --show-toplevel)"
PARENT_DIR="$(dirname "$MAIN_DIR")"
REPO_NAME="$(basename "$MAIN_DIR")"

BRANCH=$1
if [ -z "$BRANCH" ]; then
  echo "Usage: worktree-add <branch-name> [worktree-name]"
  exit 1
fi

WORKTREE_NAME=${2:-"$REPO_NAME-$BRANCH"}
WORKTREE_PATH="$PARENT_DIR/$WORKTREE_NAME"

# Create the worktree, handling local, remote, and new branches
if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
  # Branch exists locally
  git worktree add "$WORKTREE_PATH" "$BRANCH"
elif git show-ref --verify --quiet "refs/remotes/origin/$BRANCH"; then
  # Branch exists on remote only
  git worktree add "$WORKTREE_PATH" --track -b "$BRANCH" "origin/$BRANCH"
else
  # New branch
  git worktree add "$WORKTREE_PATH" -b "$BRANCH"
fi

# Symlink all .env.development.local files found anywhere in the repo
while IFS= read -r -d '' env_file; do
  relative="${env_file#$MAIN_DIR/}"
  target="$WORKTREE_PATH/$relative"
  mkdir -p "$(dirname "$target")"
  ln -s "$env_file" "$target"
done < <(find "$MAIN_DIR" -name ".env.development.local" -not -path "*/node_modules/*" -print0)

# Install deps if this is a pnpm project
if [ -f "$WORKTREE_PATH/pnpm-workspace.yaml" ] || [ -f "$WORKTREE_PATH/pnpm-lock.yaml" ]; then
  cd "$WORKTREE_PATH" && pnpm install
else
  echo "No pnpm workspace or lockfile found, skipping install"
fi

echo ""
echo "Worktree ready at $WORKTREE_PATH"
echo "  cd $WORKTREE_PATH"

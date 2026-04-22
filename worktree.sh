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

# Create the worktree
git worktree add "$WORKTREE_PATH" "$BRANCH"

# Symlink all .env.development.local files found anywhere in the repo
while IFS= read -r -d '' env_file; do
  relative="${env_file#$MAIN_DIR/}"
  target="$WORKTREE_PATH/$relative"
  mkdir -p "$(dirname "$target")"
  ln -s "$env_file" "$target"
done < <(find "$MAIN_DIR" -name ".env.development.local" -not -path "*/node_modules/*" -print0)

# Install deps
cd "$WORKTREE_PATH" && pnpm install

echo ""
echo "Worktree ready at $WORKTREE_PATH"
echo "  cd $WORKTREE_PATH"

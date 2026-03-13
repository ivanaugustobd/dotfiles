# Vars
export GIT_LAST_BRANCH="@{-1}"
export GIT_DEFAULT_BRANCH=master
export master=main

# Aliases
alias g-amend-all='git add . && git commit --amend --no-edit'
alias g-amend='git commit --amend --no-edit'
alias g-bkp-branch='git checkout -b "bkp/$(g-current-branch)"'
alias g-current-branch='git branch --show-current'
alias g-fetch-all='git fetch --all --auto-gc --prune --tags --show-forced-updates --prune-tags --progress'
alias g-init='git init && git add . && git commit -m "Initial commit"'
alias g-modified-files='g status --porcelain | grep "^ M"'
alias g-deleted-files='g status --porcelain | grep "^ D"'
alias g-new-files='g status --porcelain | grep "^??"'
alias g-safe-pull="git add . && git stash && git pull --rebase && git stash pop && git reset"
alias g-stash="git add . && git stash"
alias g-user-setup='git config user.email 4603111+ivanaugustobd@users.noreply.github.com && git config user.name "Code Slicer"'
alias g-woke-bs="git branch -m master main"

# Short aliases
alias gl="git log --oneline --graph --"
alias gs="git status"

# Functions
## Clone only the specified subfolder of a remote repository
g-clone-subdir() {
  local REPO_URL="$1"
  local SUBDIR="$2"

  if [[ -z "$REPO_URL" || -z "$SUBDIR" ]]; then
    echo "Usage: g-clone-subdir <repo-url> <subdirectory>"
    return 1
  fi

  if ! command -v git &>/dev/null; then
    echo "Error: git not found"
    return 1
  fi

  local TARGET_DIR=".repo-partial"
  git clone --depth 1 --filter=blob:none --sparse "$REPO_URL" "$TARGET_DIR" || return 1
  cd "$TARGET_DIR" || return 1
  git sparse-checkout set "$SUBDIR"
  mv "$SUBDIR" ../
  cd ..
  rm -rf "$TARGET_DIR"
}

g-blob-ids() {
  if [[ -z "$1" ]]; then
    echo "Usage: g-blob-ids <file(s)>"
    return 1
  fi

  if ! git rev-parse --git-dir &>/dev/null; then
    echo "Error: Not in a git repository"
    return 1
  fi

  for FILE in "$@"; do
    git log --format=%H -- "$FILE" | xargs -IcommitId git rev-parse "commitId:$FILE"
  done
}

g-rewrite-tag() {
  local TAG_NAME="$1"

  if [[ -z "$TAG_NAME" ]]; then
    echo "Usage: g-rewrite-tag <tag-name>"
    return 1
  fi

  if ! git rev-parse --git-dir &>/dev/null; then
    echo "Error: Not in a git repository"
    return 1
  fi

  git tag --delete "$TAG_NAME"
  git add .
  git commit --amend --no-edit
  git tag "$TAG_NAME"
}

g-version-commit() {
  if ! git rev-parse --git-dir &>/dev/null; then
    echo "Error: Not in a git repository"
    return 1
  fi

  git add .
  git commit -m "v$(date '+%Y%m%d%_H%M%S')"
}

g-which-branch-commit-is-from() {
  local COMMIT="$1"

  if [[ -z "$COMMIT" ]]; then
    echo "Usage: g-which-branch-commit-is-from <commit>"
    return 1
  fi

  git reflog show --all | grep "$COMMIT" | grep -v HEAD | awk '{print $2}' | awk -F'@' '{print $1}' | awk -F'refs/heads/|refs/remotes/' '{print $2}' | sort | uniq
}

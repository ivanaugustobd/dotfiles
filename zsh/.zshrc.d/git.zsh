# Vars
export GIT_LAST_BRANCH="@{-1}"

# Aliases
alias g-amend-all='git add . && git commit --amend --no-edit'
alias g-amend='git commit --amend --no-edit'
alias g-bkp-branch='git checkout -b "bkp/$(git current-branch)"'
alias g-current-branch='git branch --show-current'
alias g-fetch-all='git fetch --all --auto-gc --prune --tags --show-forced-updates --prune-tags --progress'
alias g-init='git init && git add . && git commit -m "Initial commit"'
alias g-safe-pull="git add . && git stash && git pull --rebase && git stash pop && git reset"
alias g-stash="git add . && git stash"
alias g-woke-bs='git branch -m master main'

# Short aliases
alias gl="git log --oneline --graph --"
alias gs="git status"

# Functions
## Clone only the specified subfolder of a remote repository
g-clone-subdir() {
  git clone --depth 1 --filter=blob:none --sparse $1 .repo-partial
  cd $_
  git sparse-checkout set $2
  mv $2 ../
  cd ..
  rm -rf .repo-partial
}

# Rewrite existent tag
g-rewrite-tag() {
  git tag --delete $1
  git add .
  git commit --amend --no-edit
  git tag $1
}

# Quick commit with current datetime as message
g-version-commit() {
  git add .
  git commit -m "v$(date '+%Y%m%d%_H%M%S')"
}

# Get the branch where given commit originated from
g-which-branch-commit-is-from() {
  git reflog show --all | grep $1 | grep -v HEAD | awk '{print $2}' | awk -F'@' '{print $1}' | awk -F'refs/heads/|refs/remotes/' '{print $2}' | sort | uniq
}

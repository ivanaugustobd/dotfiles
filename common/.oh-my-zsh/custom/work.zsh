# Common vars
export PROJECTS_DIR="$HOME/Projects"

# Editor
vscode() {
  local PROJECT_DIR="$PROJECTS_DIR/$1"

  if [[ -z "$1" ]]; then
    echo "Usage: vscode <project-name>"
    echo "Opens VS Code at ~/Projects/<project-name>"
    return 1
  fi

  if ! command -v code &>/dev/null; then
    echo "Error: 'code' command not found. Is VS Code installed?"
    return 1
  fi

  if [[ ! -d "$PROJECT_DIR" ]]; then
    echo "Error: Project directory does not exist: $PROJECT_DIR"
    return 1
  fi

  code "$PROJECT_DIR"
}

_vscode() {
  _arguments '1:project:->projects' && return 0
  local PROJECTS
  PROJECTS=($(ls -1 "$PROJECTS_DIR/" 2>/dev/null))
  _describe 'project' PROJECTS
}
compdef _vscode vscode

# Frontools
FRONTOOLS_DIR="vendor/snowdog/frontools"

_m2-frontools-check() {
  if [[ ! -d "$FRONTOOLS_DIR" ]]; then
    echo "Frontools not found at $FRONTOOLS_DIR. Skipping."
    return 1
  fi
}

m2-frontools-setup() {
  echo "Setting up frontools (this will remove the old node_modules, if present)..."
  _m2-frontools-check || return 1

  m2-cli bash -c "
    cd $FRONTOOLS_DIR &&
    ([ -d node_modules ] && trash-put node_modules || true) &&
    yarn &&
    yarn setup
  "
}

m2-frontools-compile() {
  _m2-frontools-check || return 1

  if [[ ! -d "$FRONTOOLS_DIR/node_modules" ]]; then
    echo "node_modules not found. Running setup..."
    m2-frontools-setup
  fi

  m2-cli bash -c "cd $FRONTOOLS_DIR && yarn styles && yarn babel && yarn svg"
}

m2-frontools-watch() {
  _m2-frontools-check || return 1
  m2-cli bash -c "cd $FRONTOOLS_DIR && yarn watch"
}

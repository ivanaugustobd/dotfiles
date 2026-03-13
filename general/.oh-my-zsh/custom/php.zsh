# phpenv - https://github.com/phpenv/phpenv

export PHPENV_ROOT="${PHPENV_ROOT:-$HOME/.phpenv}"

php() {
    # install phpenv if not already installed
    if [[ ! -d "$PHPENV_ROOT" ]]; then
        echo "phpenv not found. Installing phpenv..."
        phpenv-install || { echo "Failed to install phpenv."; return 1; }
    fi

    # load phpenv if not already loaded
    if ! command -v phpenv >/dev/null 2>&1; then
        _phpenv-load
    fi

    # pipe the og command through phpenv
    phpenv exec php "$@"
}

phpenv-install() {
    if [[ -d "$PHPENV_ROOT" ]]; then
        echo "phpenv is already installed at $PHPENV_ROOT."
        return 0
    fi

    # install
    curl -L https://raw.githubusercontent.com/phpenv/phpenv-installer/master/bin/phpenv-installer | bash || return 1

    # setup shell
    _phpenv-load
}

_phpenv-load() {
    export PATH="$PHPENV_ROOT/bin:$PATH"
    eval "$("$PHPENV_ROOT/bin/phpenv" init -)"
}

phpenv-init() {
    local ENV_FILE=".env"
    local PHP_VERSION
    local RESOLVED_VERSION

    if [[ ! -f "$ENV_FILE" ]]; then
        echo "Error: .env file not found in the current directory."
        return 1
    fi

    PHP_VERSION=$(grep -E '^PHP_VERSION=' "$ENV_FILE" | cut -d'=' -f2- | tr -d '"'"'" | head -n1)

    if [[ -z "$PHP_VERSION" ]]; then
        echo "Error: PHP_VERSION not set in .env file."
        return 1
    fi

    if [[ "$PHP_VERSION" =~ ^[0-9]+\.[0-9]+$ ]]; then
        RESOLVED_VERSION=$(phpenv install --list 2>/dev/null | grep -E "^\s*${PHP_VERSION}\.[0-9]+$" | tail -n1 | tr -d '[:space:]')
        if [[ -z "$RESOLVED_VERSION" ]]; then
            echo "Error: No php-build definition found for PHP ${PHP_VERSION}. Try specifying a full version (e.g. ${PHP_VERSION}.x)."
            return 1
        fi
        echo "Resolved PHP_VERSION ${PHP_VERSION} -> ${RESOLVED_VERSION}"
        PHP_VERSION="$RESOLVED_VERSION"
    fi

    phpenv install -s "$PHP_VERSION"
    phpenv local "$PHP_VERSION"
}

phpenv-uninstall() {
    trash-put "$PHPENV_ROOT"
}

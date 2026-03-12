# phpenv - https://github.com/phpenv/phpenv

export PHPENV_ROOT="${PHPENV_ROOT:-$HOME/.phpenv}"

phpenv() {
    if [[ ! -d "$PHPENV_ROOT" ]]; then
        echo "phpenv not found. Installing..."
        phpenv-install || return 1
    fi

    "$PHPENV_ROOT/bin/phpenv" "$@"
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

    if ! grep -qF '_phpenv-load' "$ZSHRC"; then
        echo '_phpenv-load' >> "$ZSHRC"
    fi
}

phpenv-init() {
    if [[ ! -f .env ]]; then
        echo "Error: .env file not found in the current directory."
        return 1
    fi

    local PHP_VERSION
    PHP_VERSION=$(grep -E '^PHP_VERSION=' .env | cut -d'=' -f2- | tr -d '"'"'" | head -n1)

    if [[ -z "$PHP_VERSION" ]]; then
        echo "Error: PHP_VERSION not set in .env file."
        return 1
    fi

    # If version is not fully qualified (e.g. "8.5" instead of "8.5.x"),
    # resolve it to the latest available patch version via php-build definitions.
    if [[ "$PHP_VERSION" =~ ^[0-9]+\.[0-9]+$ ]]; then
        local RESOLVED_VERSION
        RESOLVED_VERSION=$(phpenv install --list 2>/dev/null | grep -E "^\s*${PHP_VERSION}\.[0-9]+$" | tail -n1 | tr -d '[:space:]')
        if [[ -z "$RESOLVED_VERSION" ]]; then
            echo "Error: No php-build definition found for PHP ${PHP_VERSION}. Try specifying a full version (e.g. ${PHP_VERSION}.x)."
            return 1
        fi
        echo "Resolved PHP_VERSION ${PHP_VERSION} -> ${RESOLVED_VERSION}"
        PHP_VERSION="$RESOLVED_VERSION"
    fi

    phpenv install "$PHP_VERSION"
    phpenv local "$PHP_VERSION"
}

phpenv-update() {
    phpenv update
}

phpenv-uninstall() {
    trash-put "$PHPENV_ROOT"
    sed -i '/_phpenv-load/d' "$ZSHRC"
}

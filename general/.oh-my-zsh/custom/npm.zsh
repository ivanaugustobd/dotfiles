npm-setup-stylelint() {
    local SCRIPT_FILE="${functions_source[$0]:-${(%):-%N}}"
    local NPM_DIRECTORY="${SCRIPT_FILE:h}/npm"

    local PACKAGES_FILE="${NPM_DIRECTORY}/packages.txt"
    local STYLELINT_CONFIG_FILE="${NPM_DIRECTORY}/stylelint.config.mjs"

    if [ ! -f package.json ]; then
        npm init -y
    fi

    local -a PACKAGES_TO_INSTALL=(${(f)"$(<$PACKAGES_FILE)"})
    PACKAGES_TO_INSTALL=(${PACKAGES_TO_INSTALL:#})

    npm add --save-dev $PACKAGES_TO_INSTALL
    cp $STYLELINT_CONFIG_FILE ./
}

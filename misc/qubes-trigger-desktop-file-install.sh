#!/bin/bash -e
# vim: set ts=4 sw=4 sts=4 et :

#
# qubes-trigger-desktop-file-install.sh
#
# This trigger library contains shared functions available for 
# qubes-desktop-file-install triggers

source /etc/qubes/triggers.d/qubes-triggers.sh

QUBES_DESKTOP_FILE_INSTALL='/usr/bin/qubes-desktop-file-install'
QUBES_XDG_CONFIG_DIR=/var/lib/qubes/xdg/autostart
XDG_CONFIG_DIR=/etc/xdg/autostart

INSTALL_CMD=""${QUBES_DESKTOP_FILE_INSTALL}" --force --dir "${QUBES_XDG_CONFIG_DIR}""

# ==============================================================================
# Generate a path by prepending directory and appending .desktop suffix
# ==============================================================================
generatePath () {
    echo "${XDG_CONFIG_DIR}/${1}.desktop"
}

# ==============================================================================
# Loop through a list of filenames and generate an absolute path
# ==============================================================================
generateFileList () {
    for key in "${!FILES[@]}"; do
        FILES[${key}]="$(generatePath ${FILES[key]})"
    done
}

# ==============================================================================
# Install an edited version of .desktop files in $QUBES_XDG_CONFIG_DIR
# ==============================================================================
install () {
    local options="${@}"

    generateFileList
    $INSTALL_CMD "${@}" "${FILES[@]}" 2> /dev/null || true
}

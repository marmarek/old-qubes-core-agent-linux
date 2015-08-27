#!/bin/bash -e
# vim: set ts=4 sw=4 sts=4 et :

#
# qubes-trigger-desktop-file-install
#
# This trigger script calls qubes-desktop-file-install to installation and edit
# desktop file overrides, leaving the original desktop file in-place and
# untouched.
#
# 'qubes-desktop-file-install' options:
#   --dir DIR                          Install desktop files to the DIR directory (default: <FILE>)
#   --force                            Force overwrite of existing desktop files (default: False)
#   --remove-show-in                   Remove the "OnlyShowIn" and "NotShowIn" entries from the desktop file (default: False)
#   --remove-key KEY                   Remove the KEY key from the desktop files, if present
#   --set-key (KEY VALUE)              Set the KEY key to VALUE
#   --remove-only-show-in ENVIRONMENT  Remove ENVIRONMENT from the list of desktop environment where the desktop files should be displayed
#   --add-only-show-in ENVIRONMENT     Add ENVIRONMENT to the list of desktop environment where the desktop files should be displayed
#   --remove-not-show-in ENVIRONMENT   Remove ENVIRONMENT from the list of desktop environment where the desktop files should not be displayed
#   --add-not-show-in ENVIRONMENT      Add ENVIRONMENT to the list of desktop environment where the desktop files should not be displayed

source /etc/qubes/triggers.d/qubes-trigger-desktop-file-install.sh

# ==============================================================================
# Desktop Entry Modifications
# ==============================================================================
desktopFileInstall() {
    # --------------------------------------------------------------------------
    # NotShowIn=QUBES
    # --------------------------------------------------------------------------
    FILES=(
        'pulseaudio'
        'deja-dup-monitor'
        'imsettings-start'
        'krb5-auth-dialog'
        'restorecond'
        'sealertauto'
        'gnome-power-manager'
        'gnome-sound-applet'
        'gnome-screensaver'
        'orca-autostart'
        'notify-osd'
    ); install --remove-show-in --add-not-show-in X-QUBES

    # --------------------------------------------------------------------------
    # NotShowIn=DisposableVM
    # --------------------------------------------------------------------------
    FILES=(
        'gcm-apply'
    ); install  --remove-show-in --add-not-show-in X-DisposableVM 

    # --------------------------------------------------------------------------
    # OnlyShowIn=GNOME;AppVM;
    # --------------------------------------------------------------------------
    FILES=(
        'gnome-keyring-gpg'
        'gnome-keyring-pkcs11'
        'gnome-keyring-secrets'
        'gnome-keyring-ssh'
        'gnome-settings-daemon'
        'user-dirs-update-gtk'
        'gsettings-data-convert'
    ); install --remove-show-in --add-only-show-in 'GNOME;X-AppVM'

    # --------------------------------------------------------------------------
    # OnlyShowIn=GNOME;UpdateableVM
    # --------------------------------------------------------------------------
    FILES=('gpk-update-icon')
    install --remove-show-in --add-only-show-in 'GNOME;X-UpdateableVM'

    # --------------------------------------------------------------------------
    # OnlyShowIn=GNOME;QUBES
    # --------------------------------------------------------------------------
    FILES=(
        'nm-applet'
    ); install --remove-show-in --add-only-show-in 'GNOME;X-QUBES'

    # --------------------------------------------------------------------------
    # Remove existing rules
    # --------------------------------------------------------------------------
    FILES=(
        'abrt-applet'
    ); install --remove-show-in
}

case "${1}" in
    configure)
        rm -f "${QUBES_XDG_CONFIG_DIR}"/*
        run desktopFileInstall || true
        ;;
    
    triggered)
        shift
        for trigger in ${@}; do
            case "${trigger}" in
                /usr/share/applications | \
                /etc/xdg)
                    echo "Updating Desktop Entry Overrides..."
                    run desktopFileInstall || true
                    ;;
            esac
        done
        ;;
esac

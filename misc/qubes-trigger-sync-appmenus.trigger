#!/bin/bash
# vim: set ts=4 sw=4 sts=4 et :

source /etc/qubes/triggers.d/qubes-triggers.sh

# ==============================================================================
# Sync Qubes App Menus
# ==============================================================================
syncAppMenus() {
    UPDATEABLE=`qubesdb-read /qubes-vm-updateable`

    if [ "$UPDATEABLE" = "True" ]; then
        echo "Syncing AppMenus..."
        /usr/lib/qubes/qrexec-client-vm dom0 qubes.SyncAppMenus /bin/sh /etc/qubes-rpc/qubes.GetAppmenus
    fi
}

# ==============================================================================
# Trigger
# ==============================================================================
case "${1}" in
    triggered)
        shift
        for trigger in ${@}; do
            case "${trigger}" in
                sync-appmenus)
                    run syncAppMenus || true
                    ;;
            esac
        done
        ;;
esac

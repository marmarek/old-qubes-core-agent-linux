#!/bin/bash

# Check if at least two arguments are provided: actions + file(s)
if [ "$#" -le 1 ]; then
    echo "Not enough arguments provided. Aborting..."
fi

# Action
action="$1"

shift

# copy and move handle a list of files where other actions don't
case "$action" in
    copy)
        #shellcheck disable=SC2016
        qvm-copy-to-vm '$default' "$@" | zenity --notification --text="Copying files..." --timeout 3
        ;;
    move)
        #shellcheck disable=SC2016
        qvm-move-to-vm '$default' "$@" | zenity --notification --text="Moving files..." --timeout 3
        ;;
    img)
        for file in "$@"
        do
            /usr/lib/qubes/qvm-convert-img.gnome "$file"
        done
        ;;
    pdf)
        for file in "$@"
        do
            /usr/lib/qubes/qvm-convert-pdf.gnome "$file"
        done
        ;;
    openvm)
        for file in "$@"
        do
            #shellcheck disable=SC2016
            qvm-open-in-vm '$default' "$file" | zenity --notification --text "Opening $file in VM..." --timeout 3 &
        done
        ;;
    opendvm)
        for file in "$@"
        do
            qvm-open-in-dvm "$file" | zenity --notification --text "Opening $file in DisposableVM..." --timeout 3 &
        done
        ;;
    *)
        echo "Unknown action. Aborting..."
        exit 1
      ;;
esac

#!/bin/bash -e
# vim: set ts=4 sw=4 sts=4 et :

#
# qubes-triggers.sh
#
# This trigger library contains shared functions available for triggers

DONE=()

# ==============================================================================
# Checks to see if $1 is present within $2
# ==============================================================================
elementIn() {
  # $1: element to check for
  # $2: array to check for element in
  local element
  for element in "${@:2}"; do [[ "$element" == "$1" ]] && return 0; done
  return 1
}

# ==============================================================================
# Prevents multiple executions when multiple paths passed for same function
# ==============================================================================
run() {
    local fun
    fun="${1}"
    shift
    
    if elementIn "${fun}" "${DONE[@]}"; then
        return
    fi

    $fun $@
    DONE+=("${fun}")
}

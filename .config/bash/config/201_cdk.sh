#!/bin/bash

function _cdk_completer {
    STACK_CMDS="list synthesize bootstrap deploy destroy diff metadata init context docs doctor"
    COMPREPLY=()
    if [ "$3" == "cdk" ]; then
        mapfile -t COMPREPLY < <(compgen -W "$STACK_CMDS" -- "$2")
    elif [[ -d "cdk.out" ]] && ! [[ "$2" == "-"* ]]; then
        TEMPLATES=$(find cdk.out/*.template.json | awk '{split($0,t,/\/|\./); print t[3]}')
        mapfile -t COMPREPLY < <(compgen -W "$TEMPLATES" -- "$2")
    else
        :
  fi
}

complete -F _cdk_completer cdk

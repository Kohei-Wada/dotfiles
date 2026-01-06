#!/bin/zsh

_log_info "Setting up CDK completion..."

# CDK completion for zsh
_cdk() {
    local -a stack_cmds
    stack_cmds=(
        'list:List stacks in the app'
        'synthesize:Synthesize CloudFormation template'
        'bootstrap:Deploy bootstrap stack'
        'deploy:Deploy stack(s)'
        'destroy:Destroy stack(s)'
        'diff:Show diff against deployed stack'
        'metadata:Show metadata for stack'
        'init:Create a new CDK project'
        'context:Manage cached context values'
        'docs:Open CDK documentation'
        'doctor:Check your CDK setup'
    )

    local curcontext="$curcontext" state line
    typeset -A opt_args

    _arguments -C \
        '1:command:->command' \
        '*:stack:->stack'

    case $state in
        command)
            _describe -t commands 'cdk commands' stack_cmds
            ;;
        stack)
            # Complete stack names from cdk.out if it exists
            if [[ -d "cdk.out" ]] && [[ "$words[CURRENT]" != -* ]]; then
                local -a templates
                templates=(${(f)"$(find cdk.out -name '*.template.json' 2>/dev/null | sed 's|.*/||; s|\.template\.json||')"})
                if [[ ${#templates[@]} -gt 0 ]]; then
                    _describe -t stacks 'CDK stacks' templates
                fi
            fi
            ;;
    esac
}

compdef _cdk cdk

_log_ok "CDK completion set up successfully."

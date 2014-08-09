#!/bin/sh
_composer()
{
    local cur prev coms opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    coms="about archive browse clear-cache config create-project depends diagnose dump-autoload global help init install licenses list remove require run-script search self-update show status update validate"
    opts="--help --quiet --verbose --version --ansi --no-ansi --no-interaction --profile --working-dir"

    if [[ ${COMP_CWORD} = 1 ]] ; then
        COMPREPLY=($(compgen -W "${coms}" -- ${cur}))
        return 0
    fi

    case "${prev}" in
            archive)
            opts="${opts} --format --dir"
            ;;    browse)
            opts="${opts} --homepage"
            ;;    config)
            opts="${opts} --global --editor --auth --unset --list --file"
            ;;    create-project)
            opts="${opts} --stability --prefer-source --prefer-dist --repository-url --dev --no-dev --no-plugins --no-custom-installers --no-scripts --no-progress --keep-vcs --no-install"
            ;;    depends)
            opts="${opts} --link-type"
            ;;    dump-autoload)
            opts="${opts} --optimize --no-dev"
            ;;    help)
            opts="${opts} --xml --format --raw"
            ;;    init)
            opts="${opts} --name --description --author --homepage --require --require-dev --stability --license"
            ;;    install)
            opts="${opts} --prefer-source --prefer-dist --dry-run --dev --no-dev --no-plugins --no-custom-installers --no-scripts --no-progress --optimize-autoloader"
            ;;    licenses)
            opts="${opts} --format"
            ;;    list)
            opts="${opts} --xml --raw --format"
            ;;    remove)
            opts="${opts} --dev --no-progress --no-update --update-no-dev --update-with-dependencies"
            ;;    require)
            opts="${opts} --dev --prefer-source --prefer-dist --no-progress --no-update --update-no-dev --update-with-dependencies"
            ;;    run-script)
            opts="${opts} --dev --no-dev"
            ;;    search)
            opts="${opts} --only-name"
            ;;    self-update)
            opts="${opts} --rollback --clean-backups"
            ;;    show)
            opts="${opts} --installed --platform --available --self --name-only --path"
            ;;    update)
            opts="${opts} --prefer-source --prefer-dist --dry-run --dev --no-dev --lock --no-plugins --no-custom-installers --no-scripts --no-progress --with-dependencies --optimize-autoloader"
            ;;    validate)
            opts="${opts} --no-check-all"
            ;;
        esac

    COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
    return 0;
}

complete -o default -F _composer composer
COMP_WORDBREAKS=${COMP_WORDBREAKS//:}

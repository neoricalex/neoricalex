#!/bin/bash

# Variáveis de Ambiente
export NEORICALEX_HOME=$(pwd)
export NFDOS_VERSAO="0.4.4"

# Checkando se o ~/.tmux.conf existe
if [ ! -f "~/.tmux.conf" ]; then
    cp $NEORICALEX_HOME/.tmux.conf ~/.tmux.conf
fi

# Atualizar ~/.tmux.conf
conf_original="~/.tmux.conf"
conf_mesclada="$NEORICALEX_HOME/.tmux.conf"
if [ -f "$conf_original" ] ; then
    cat $conf_original $conf_mesclada > $conf_original
    tmux source-file ~/.tmux.conf
fi

# Criar o Log
log_original="$NEORICALEX_HOME/logs"
github_log="https://github.com/neoricalex/tmux-logging.git"
if [ ! -d "$log_original" ] ; then
    git clone $github_log $log_original
fi

iniciar_desenvolvimento(){
    if ! tmux has-session -t nfdos 2>/dev/null; then
        tmux new-session -s nfdos bash "$NEORICALEX_HOME/iniciar_desenvolvimento.sh"
    fi
    tmux kill-session -t nfdos
    echo ""
    echo "Tempo de compilação:"
}

time iniciar_desenvolvimento

cat *.log

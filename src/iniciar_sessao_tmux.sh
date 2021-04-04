#!/bin/bash

configurar_tmux(){
	echo "==> Checkando se o ~/.tmux.conf existe"
	if [ ! -f "~/.tmux.conf" ]; then
		cp $NEORICALEX_HOME/.tmux.conf ~/.tmux.conf
	else
		echo "==> Mesclando o ~/.tmux.conf"
		conf_original="~/.tmux.conf"
		conf_mesclada="$NEORICALEX_HOME/.tmux.conf"
		cat $conf_original $conf_mesclada > $conf_original
		tmux source-file ~/.tmux.conf
	fi	
}

iniciar_desenvolvimento(){

	configurar_tmux
    if ! tmux has-session -t nfdos 2>/dev/null; then
        tmux new-session -s nfdos bash "$NEORICALEX_HOME/sessao_tmux.sh"
    fi
    tmux kill-session -t nfdos
    echo ""
    echo "Tempo de compilação:"

}

time iniciar_desenvolvimento

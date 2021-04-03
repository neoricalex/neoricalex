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

checkar_atualizacoes_modulos(){

	echo "==> Checkando por atualizações no módulo do Log..."
	caminho_log="$NEORICALEX_HOME/log"
	git submodule update
	cd $caminho_log
	git checkout master
	git pull
	cd $NEORICALEX_HOME

	echo "==> Checkando por atualizações no módulo do VPS..."
	caminho_vps="$NEORICALEX_HOME/vps"
	cd $caminho_vps
	git submodule update --init --recursive
	git submodule foreach --recursive git fetch
	git submodule foreach git merge origin master
	cd $NEORICALEX_HOME
}


iniciar_desenvolvimento(){

	configurar_tmux
	checkar_atualizacoes_modulos
    if ! tmux has-session -t nfdos 2>/dev/null; then
        tmux new-session -s nfdos bash "$NEORICALEX_HOME/sessao_tmux.sh"
    fi
    tmux kill-session -t nfdos
    echo ""
    echo "Tempo de compilação:"

}

time iniciar_desenvolvimento

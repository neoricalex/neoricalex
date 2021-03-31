#!/bin/bash

iniciar_log(){
    # Iniciar o LOG
    if compgen -G "${NEORICALEX_HOME}/vps/*.log" > /dev/null; then
        rm ./vps/*.log
    else
        echo "[DEBUG]"
        echo "      Nenhum LOG encontrado."
        echo "      Para ligar o sistema de LOG's pressione as teclas: \"CTRL b\" (sem aspas) seguido de \"SHIFT p\" (também sem aspas)"
    fi

	# Inicia uma contagem decrescente
    hora=0
    minuto=0
    segundo=10
        while [ $hora -ge 0 ]; do
            while [ $minuto -ge 0 ]; do
                while [ $segundo -ge 0 ]; do
                    echo -ne " A compilação vai iniciar em $segundo segundos...\r"
                    let "segundo=segundo-1"
                    sleep 1
                done
                segundo=59
                let "minuto=minuto-1"
            done
            minuto=59
            let "hora=hora-1"
        done

    echo ""
    echo ""
}

iniciar_detalhes(){

	# TODO: Arrumar esta salganhada
    agora=$(date +"%c")
    echo "Compilação iniciada $agora"
    echo ""
    echo "Detalhes do $HOSTNAME:" 
    echo ""
    echo "$(lscpu | awk 'NR==14{print $1 " " $2 " " $3 " " $4 " " $5 " " $6; exit}')" # Nome do modelo da CPU
    echo "Arquitetura: $QEMU_ARCH"
    echo "Número de $(lscpu | awk 'NR==5{print $1 " " $2 " " $3 " " $4 " " $5 " " $6; exit}')" # Número de CPU(s)
    echo "$(lscpu | awk 'NR==21{print $1 " " $2 " " $3 " " $4 " " $5 " " $6; exit}')" # Virtualização
    echo "Memória RAM: $(($(getconf _PHYS_PAGES) * $(getconf PAGE_SIZE) / (1024 * 1024))) MiB " # Memória RAM física
    echo "Memória Virtual: $(($(getconf _AVPHYS_PAGES) * $(getconf PAGE_SIZE) / (1024 * 1024))) MB" # Memória Virtual
    echo "$(lscpu | awk 'NR==2{print $1 " " $2 " " $3 " " $4 " " $5 " " $6; exit}')" # Modo(s) operacional da CPU
    echo ""
}

iniciar_desenvolvimento_local(){

    iniciar_log
    iniciar_detalhes
    cd vps
    make vps
	cd ..
	
}

iniciar_desenvolvimento_travis(){

    cd vps

	echo "==> Provisionando o NFDOS..."
    vagrant up
	echo "==> Entrando no NFDOS..."
    vagrant ssh <<ENTRAR_VPS
#!/bin/bash

echo "Parece Bom!"
$USER@$HOSTNAME

ENTRAR_VPS

    cd ..

}

case $HOSTNAME in
  (desktop1) iniciar_desenvolvimento_travis;;
  (*)   iniciar_desenvolvimento_local;;
esac

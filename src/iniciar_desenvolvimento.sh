#!/bin/bash
iniciar_log(){
    # Iniciar o LOG
    if compgen -G "${NEORICALEX_HOME}/*.log" > /dev/null; then
        rm *.log
    else
        echo "[DEBUG]"
        echo "      Nenhum LOG encontrado."
        echo "      Para ligar o sistema de LOG's pressione as teclas: \"CTRL b\" (sem aspas) seguido de \"SHIFT p\" (também sem aspas)"
    fi

    hour=0
    min=0
    sec=10
        while [ $hour -ge 0 ]; do
            while [ $min -ge 0 ]; do
                while [ $sec -ge 0 ]; do
                    echo -ne " A compilação vai iniciar em $sec segundos...\r"
                    let "sec=sec-1"
                    sleep 1
                done
                sec=59
                let "min=min-1"
            done
            min=59
            let "hour=hour-1"
        done

    echo ""
    echo ""
}

iniciar_detalhes(){
    agora=$(date +"%c")
    echo "Compilação iniciada $agora"
    echo ""
    echo "Detalhes do $HOSTNAME:" 
    echo ""
    echo "$(lscpu | awk 'NR==14{print $1 " " $2 " " $3 " " $4 " " $5 " " $6; exit}')" # Nome do modelo da CPU
    export QEMU_ARCH=$(lscpu | awk 'NR==1{print $2; exit}')
    export PLATFORM=$QEMU_ARCH
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
    make vps
    cd ..

}

case $HOSTNAME in
  (desktop1) iniciar_desenvolvimento_travis;;
  (*)   iniciar_desenvolvimento_local;;
esac

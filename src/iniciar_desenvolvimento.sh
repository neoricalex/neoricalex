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

iniciar_rootfs(){
    if [[ "$(docker images -q nfdos/core/rootfs:latest 2> /dev/null)" == "" ]]; then

        if [ ! -d "nfdos/core/rootfs" ]; then
            sudo debootstrap --arch=amd64 --variant=minbase focal nfdos/core/rootfs
            sudo tar -C nfdos/core/rootfs -c . | sudo docker import - nfdos/core/rootfs
        fi

        make build

    fi
}

iniciar_desenvolvimento_local(){

    cd vps

    iniciar_rootfs
    #sudo rm -rf nfdos/core/rootfs
    #sudo apt autoremove -y
    docker run -it --rm --name neoricalex nfdos/core/rootfs

    #chmod +x compilar.sh
    #./compilar.sh
    #chmod +x upload_cloud.sh
    #./upload_cloud.sh
}

iniciar_vps(){
    vagrant up
    vagrant ssh <<EOF
    #!/bin/bash

    cd /vagrant
    iniciar_rootfs
    cd ..
EOF
}

iniciar_desenvolvimento_travis(){
    cd vps
    if vagrant status | grep "not created" > /dev/null; then
        iniciar_vps
    elif vagrant status | grep "is running" > /dev/null; then
        echo "[DEBUG] O VPS existe e está ligado. Destruir e começar de novo?"
        vagrant destroy
        iniciar_vps
    elif vagrant status | grep "poweroff" > /dev/null; then
        echo "[DEBUG] O VPS existe mas está desligado. Destruir e começar de novo..."
        vagrant destroy -f
        iniciar_vps
    else
        echo "[DEBUG] O VPS existe mas está com um status diferente..."
        vagrant status
        sleep 5
    fi
    cd ..
}

case $HOSTNAME in
  (desktop) iniciar_desenvolvimento_travis;;
  (*)   iniciar_desenvolvimento_local;;
esac
#!/bin/bash
# Fazer o Upload do VPS para a Cloud do Vagrant
usuario="$(whoami)@$(hostname | cut -d . -f 1-2)"
if [ "$usuario" == "neo@desktop" ]; then
        HEIGHT=15
        WIDTH=40
        CHOICE_HEIGHT=4
        BACKTITLE="Backtitle here"
        TITLE="Upload para a Cloud"
        MENU="Choose one of the following options:"

        OPTIONS=(1 "Não"
                2 "Sim"
                3 "Option 3")

        CHOICE=$(dialog --clear \
                        --backtitle "$BACKTITLE" \
                        --title "$TITLE" \
                        --menu "$MENU" \
                        $HEIGHT $WIDTH $CHOICE_HEIGHT \
                        "${OPTIONS[@]}" \
                        2>&1 >/dev/tty)

        #clear
        case $CHOICE in
                1)
                echo "Opção 1"
                ;;
                2)
                vagrant cloud auth login
                vagrant cloud publish \
                --box-version $NFDOS_VERSAO \
                --release \
                --short-description "Ubuntu from scratch coded with Portuguese Language" \
                --version-description "Adicionar late_command do d-i" \
                neoricalex/nfdos $NFDOS_VERSAO virtualbox \
                nfdos/desktop/vagrant/NFDOS-$NFDOS_VERSAO.box # --force --debug
                vagrant cloud auth logout
                ;;
                3)
                echo "Opção 3"
                ;;
        esac
fi
#vagrant cloud publish --box-version 0.4.4 --release neoricalex/nfdos 0.4.4 virtualbox src/vps/nfdos/desktop/vagrant/NFDOS-0.4.4.box

exit
# Fazer o Upload da inagem base do docker
if [ ! -d "core" ] ; then
        usuario="$(whoami)@$(hostname | cut -d . -f 1-2)"
        if [ "$usuario" == "neo@desktop" ]; then
                sudo debootstrap --arch=amd64 --variant=minbase focal core
                sudo tar -C core -c . | sudo docker import - core
                sudo docker tag core neoricalex/nfdos
                sudo docker login
                sudo docker push neoricalex/nfdos
                sudo docker logout
        fi
fi


# TODO: Fazer o Upload do NEORICALEX para o github
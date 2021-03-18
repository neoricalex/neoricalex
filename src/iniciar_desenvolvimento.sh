#!/bin/bash

criar_vps_base(){
    echo "[DEBUG] VPS_BASE: OK!"
    echo "$USER@$HOSTNAME"
}

criar_vps_dev(){
    echo "[DEBUG] VPS_DEV: OK!"
    echo "$USER@$HOSTNAME"
    shopt +s extglob
    sleep 5
    exit
}


case $HOSTNAME in
  (travis-job-*) criar_vps_base;;
  (*)   criar_vps_dev;;
esac
exit

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
agora=$(date +"%c")
echo "Compilação iniciada $agora"
echo ""
echo "Detalhes do $HOSTNAME:" 
echo ""
echo "$(lscpu | awk 'NR==14{print $1 " " $2 " " $3 " " $4 " " $5 " " $6; exit}')"
echo "$(lscpu | awk 'NR==1{print $1 " " $2; exit}')"
echo "Número de $(lscpu | awk 'NR==5{print $1 " " $2 " " $3 " " $4 " " $5 " " $6; exit}')"
echo "$(lscpu | awk 'NR==21{print $1 " " $2 " " $3 " " $4 " " $5 " " $6; exit}')"
echo "$(lscpu | awk 'NR==2{print $1 " " $2 " " $3 " " $4 " " $5 " " $6; exit}')"
echo ""

chmod +x compilar.sh
./compilar.sh
chmod +x upload_cloud.sh
#./upload_cloud.sh
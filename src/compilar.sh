#!/bin/bash

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

# Iniciar o VPS
# REF: https://github.com/neoricalex/baseimage-docker.git
cd vps

vagrant destroy
vagrant up
vagrant ssh <<EOF
#!/bin/bash
cd /vagrant
make vps
cd ..
EOF
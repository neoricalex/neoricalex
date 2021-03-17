#!/bin/bash

agora=$(date +"%c")
echo "Compilação iniciada $agora"

chmod +x compilar.sh
./compilar.sh
chmod +x upload_cloud.sh
#./upload_cloud.sh
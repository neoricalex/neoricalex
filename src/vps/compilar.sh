#!/bin/bash

# Iniciar o VPS
# REF: https://github.com/neoricalex/baseimage-docker.git

vagrant destroy
vagrant up
vagrant ssh <<EOF
#!/bin/bash
cd /vagrant
make vps
cd ..
EOF

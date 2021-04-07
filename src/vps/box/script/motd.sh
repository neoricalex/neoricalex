#!/bin/bash -eu

echo "==> Recording box generation date"
date > /etc/vagrant_box_build_date

echo "==> Customizar o MOTD"
MOTD_FILE=/etc/motd
BANNER_WIDTH=64
PLATFORM_RELEASE=$(lsb_release -sd)
PLATFORM_MSG=$(printf '%s' "$PLATFORM_RELEASE")
BUILT_MSG=$(printf 'compilado em %s' $(date +%d-%m-%Y))
printf '%0.1s' "-"{1..64} > ${MOTD_FILE}
printf '\n' >> ${MOTD_FILE}
printf '%2s%-30s%30s\n' " " "${PLATFORM_MSG}" "${BUILT_MSG}" >> ${MOTD_FILE}
printf '%0.1s' "-"{1..64} >> ${MOTD_FILE}
printf '\n' >> ${MOTD_FILE}

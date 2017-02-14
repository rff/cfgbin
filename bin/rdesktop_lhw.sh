#!/bin/bash

HOSTIP=172.29.1.30
HOSTNAME=00000.padtec.com.br

GEOMETRY_PUTTY='906x563'
GEOMETRY_SMALL='1000x1000'
GEOMETRY_BIG='1800x1080'

HOST=${HOSTIP}
GEOMETRY=${GEOMETRY_PUTTY}

#rdesktop -d BRCPSDHW06 -u Administrador -p '!padtec' -g ${GEOMETRY} -k pt-br -K "$@" ${HOST}
rdesktop -d BRCPSDHW06 -u Administrador -p '!padtec' -k pt-br -K "$@" ${HOST}

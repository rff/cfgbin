#!/bin/bash

HOSTIP=172.16.4.121
HOSTNAME=netuno.padtec.com.br

GEOMETRY_SMALL='1000x1000'
GEOMETRY_BIG='1800x1080'

rdesktop -d PADTEC -u rfirmino -g ${GEOMETRY_SMALL} "$@" ${HOSTNAME}

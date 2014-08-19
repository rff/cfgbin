#!/bin/bash

[ $# -ne 1 ] && exit 1

hostname_new=${1}

hostname_def='ubuntu-freshinstall'
hostname_var=${HOSTNAME}
hostname_arq=$(cat /etc/hostname)
hostname_cmd=$(hostname)

hostname ${hostname_new}                                             || exit $?
echo ${hostname_new} > /etc/hostname                                 || exit $?

# We try our best to find the hostname in the hosts that is the localhost. We
# do it without assumptions about the ip associated with it.
perl -p -i'.bkp' -e "s/${hostname_def}/${hostname_new}/" /etc/hosts  || exit $?
perl -p -i'.bkp' -e "s/${hostname_var}/${hostname_new}/" /etc/hosts  || exit $?
perl -p -i'.bkp' -e "s/${hostname_arq}/${hostname_new}/" /etc/hosts  || exit $?
perl -p -i'.bkp' -e "s/${hostname_cmd}/${hostname_new}/" /etc/hosts  || exit $?

exit 0

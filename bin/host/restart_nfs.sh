#!/bin/bash

#/**
# * Restart local NFS server
# *
# * @category host
# * @version  0.1.0
# * @licence  MIT
# * @author   "Matthias Morin" <mat@tangoman.io>
# */

BASEDIR=$(dirname "${0}")
. ${BASEDIR}/../tools/colors.sh

echo_title 'Restart local NFS server'

if [ -n "$(dpkg -la | grep nfs-common)" ] && [ -n "$(dpkg -la | grep nfs-kernel-server)" ]; then
    {
        echo_info 'sudo service nfs-kernel-server restart'
        sudo service nfs-kernel-server restart
    } || {
        echo_error 'Could not restart "nfs-kernel-server"'
    }
else
    echo_info "NFS not installed"
fi

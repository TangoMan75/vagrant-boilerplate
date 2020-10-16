#!/bin/bash

#/**
# * Uninstall All
# *
# * @category host
# * @version  0.1.0
# * @licence  MIT
# * @author   "Matthias Morin" <mat@tangoman.io>
# */

BASEDIR=$(dirname "${0}")
. ${BASEDIR}/../tools/colors.sh

if [ -n "$(vagrant status | grep 'running')" ]; then
    {
        echo_warning 'Vagrant running, attempting to stop'
        echo_info 'vagrant halt'
        vagrant halt
    } || {
        echo_error 'Stopping Vagrant failed'
    }
fi

if [ -z "$(vagrant status | grep 'running')" ]; then
    # uninstall virtualbox
    echo_caption 'uninstall virtualbox'
    echo_info 'sudo apt-get remove -y virtualbox-5.2'
    sudo apt-get remove -y virtualbox-5.2

    echo_info 'sudo apt-get remove -y virtualbox'
    sudo apt-get remove -y virtualbox

    echo_info 'sudo groupdel vboxusers'
    sudo groupdel vboxusers
fi

# uninstall vagrant
echo_caption 'uninstall vagrant'
echo_info 'sudo rm -rf /opt/vagrant'
sudo rm -rf /opt/vagrant

echo_info 'sudo rm -f /usr/bin/vagrant'
sudo rm -f /usr/bin/vagrant

echo_info 'sudo rm -rf ~/.vagrant.d'
sudo rm -rf ~/.vagrant.d

echo_info 'sudo apt-get remove -y --autoremove vagrant'
sudo apt-get remove -y --autoremove vagrant

echo_info 'sudo dpkg -r vagrant'
sudo dpkg -r vagrant

# uninstall ansible
echo_info 'sudo apt-get remove -y --autoremove ansible'
sudo apt-get remove -y --autoremove ansible

# uninstall mokutil
echo_info 'sudo apt-get remove -y --autoremove mokutil'
sudo apt-get remove -y --autoremove mokutil

# stopping nfs-kernel-server
echo_info 'sudo service nfs-kernel-server stop'
sudo service nfs-kernel-server stop

# uninstall nfs server
echo_caption 'uninstall nfs'
echo_info 'sudo dpkg --purge nfs-kernel-server'
sudo dpkg --purge nfs-kernel-server

echo_info 'sudo dpkg --purge nfs-common'
sudo dpkg --purge nfs-common

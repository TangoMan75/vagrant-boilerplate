#!/bin/bash

#/**
# * Start Vagrant
# *
# * @category host
# * @version  0.1.0
# * @licence  MIT
# * @author   "Matthias Morin" <mat@tangoman.io>
# */

BASEDIR=$(dirname "${0}")
. ${BASEDIR}/../tools/colors.sh

echo_title 'Starting Vagrant'

echo_info 'vagrant status'
vagrant status

if [ -z "$(vagrant status | grep 'running')" ]; then
    {
        echo_warning 'Vagrant not running, attempting to start'
        echo_info 'vagrant up'
        vagrant up
    } || {
        echo_error 'Starting Vagrant failed'
    }
else
    echo_success 'Vagrant is up !!!'
fi

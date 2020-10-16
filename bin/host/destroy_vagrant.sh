#!/bin/bash

#/**
# * Destroy Vagrant
# *
# * @category host
# * @version  0.1.0
# * @licence  MIT
# * @author   "Matthias Morin" <mat@tangoman.io>
# */

BASEDIR=$(dirname "${0}")
. ${BASEDIR}/../tools/colors.sh
. ${BASEDIR}/../tools/yaml.sh

CONFIG=${BASEDIR}/../../config/vagrant.yaml

echo_title 'Destroy Vagrant'

BOX_NAME="$(get_parameter 'box_name' -f ${CONFIG})"

{
    echo_info "vagrant destroy ${BOX_NAME} --force" &&
    vagrant destroy ${BOX_NAME} --force
} || {
    echo_error 'Could not destroy vagrant'
}

{
    echo_info 'rm -rf .vagrant' &&
    rm -rf .vagrant
} || {
    echo_error 'Could not remove .vagrant'
}

{
    echo_info 'rm -f *.log' &&
    rm -f *.log
} || {
    echo_error 'Could not remove logs'
}

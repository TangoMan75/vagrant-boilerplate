#!/bin/bash

#/**
# * Set Hosts
# *
# * @category host
# * @version  0.1.0
# * @licence  MIT
# * @author   "Matthias Morin" <mat@tangoman.io>
# */

BASEDIR=$(dirname "${0}")
. ${BASEDIR}/../tools/colors.sh
. ${BASEDIR}/../tools/yaml.sh
. ${BASEDIR}/../tools/tools.sh
. ${BASEDIR}/../tools/hosts.sh

echo_title 'Set Hosts'
echo_info  'Note: This script can set one host and one only,'
echo_info  "if you wish to set up more, you'll need to do it yourself"

CONFIG="${BASEDIR}/../../config/vagrant.yaml"
HOST_ONLY_IP=$(get_parameter 'host_only_ip' -f "${CONFIG}")
BOX_NAME=$(get_parameter 'box_name' -f "${CONFIG}")

if [ $? = 0 ]; then
    echo_info "set-hosts \"${BOX_NAME}.localhost\" -i \"${HOST_ONLY_IP}\""
    set-hosts "${BOX_NAME}.localhost" -i "${HOST_ONLY_IP}"
else
    echo_error 'Config file not found, run `make config` to create one'
    exit 1
fi

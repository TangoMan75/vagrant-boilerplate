#!/bin/bash

#/**
# * Create vagrant Guest
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

echo_title 'Create vagrant Guest'

CONFIG="${BASEDIR}/../../config/vagrant.yaml"
BOX_TYPE=$(get_parameter 'box_type' -f "${CONFIG}")

if [ $? = 0 ]; then
    echo_info "vagrant box add \"${BOX_TYPE}\""
    vagrant box add "${BOX_TYPE}" --force
else
    echo_error 'Config file not found, run `make config` to create one'
    exit 1
fi

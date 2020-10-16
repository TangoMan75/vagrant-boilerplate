#!/bin/bash

#/**
# * Initialize Vagrant Configuration
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

echo_title 'Vagrant Config'
echo
echo_primary 'Please set your vagrant config:'
echo

CONFIG_DIST=${BASEDIR}/../../config/vagrant.yaml.dist
CONFIG=${BASEDIR}/../../config/vagrant.yaml

if [ -f "${CONFIG}" ]; then
    if [ `prompt_user 'Overwrite vagrant.yaml?' -y -d 'yes'` == 'yes' ]; then
        echo_warning 'Reset parameters'
        echo_info "rm -f \"${CONFIG}\""

        rm -f "${CONFIG}"
    else
        echo_info 'Setting several virtual machines on the same vagrant'
    fi
fi

# get default values from `vagrant.yaml.dist`
DEFAULT_BOX_NAME="$(get_parameter 'box_name' -f ${CONFIG_DIST})"
DEFAULT_BOX_TYPE="$(get_parameter 'box_type' -f ${CONFIG_DIST})"
DEFAULT_SHOW_GUI="$(get_parameter 'show_gui' -f ${CONFIG_DIST})"
DEFAULT_VIDEO_MEMORY_MO="$(get_parameter 'video_memory_mo' -f ${CONFIG_DIST})"
DEFAULT_DISK_SIZE="$(get_parameter 'disk_size' -f ${CONFIG_DIST})"
DEFAULT_MEMORY_LIMIT_MO="$(get_parameter 'memory_limit_mo' -f ${CONFIG_DIST})"
DEFAULT_CPU_NUMBER="$(get_parameter 'cpu_number' -f ${CONFIG_DIST})"
DEFAULT_HOST_ONLY_IP="$(get_parameter 'host_only_ip' -f ${CONFIG_DIST})"
DEFAULT_INTNET_IP="$(get_parameter 'intnet_ip' -f ${CONFIG_DIST})"
DEFAULT_PUBLIC_IP="$(get_parameter 'public_ip' -f ${CONFIG_DIST})"

# prompt user values
BOX_NAME=$(prompt_user 'box_name' -d "${DEFAULT_BOX_NAME}")
BOX_TYPE=$(prompt_user 'box_type' -d "${DEFAULT_BOX_TYPE}")
SHOW_GUI=$(prompt_user 'show_gui' -b -d "${DEFAULT_SHOW_GUI}")
VIDEO_MEMORY_MO=$(prompt_user 'video_memory_mo' -d "${DEFAULT_VIDEO_MEMORY_MO}")
DISK_SIZE=$(prompt_user 'disk_size' -d "${DEFAULT_DISK_SIZE}")
MEMORY_LIMIT_MO=$(prompt_user 'memory_limit_mo' -d "${DEFAULT_MEMORY_LIMIT_MO}")
CPU_NUMBER=$(prompt_user 'cpu_number' -d "${DEFAULT_CPU_NUMBER}")
HOST_ONLY_IP=$(prompt_user 'host_only_ip' -d "${DEFAULT_HOST_ONLY_IP}")
INTNET_IP=$(prompt_user 'intnet_ip' -d "${DEFAULT_INTNET_IP}")
PUBLIC_IP=$(prompt_user 'public_ip' -d "${DEFAULT_PUBLIC_IP}")

#/**
# * get host adapters
# */
if [ `is_installed 'ip'` = true ]; then
    DEFAULT_ADAPTERS="$(printf "%s " `ip token | cut -d' ' -f4`)"
else
    DEFAULT_ADAPTERS="$(printf "%s " `ifconfig | grep -E '^\w+:' | cut -d: -f1`)"
fi

DEFAULT_ETHERNET="$(ip token | cut -d' ' -f4 | grep -E '^e' | head -n1)"
DEFAULT_WIFI="$(ip token | cut -d' ' -f4 | grep -E '^w' | head -n1)"
BRIDGE=$(prompt_user "bridge (${DEFAULT_ADAPTERS::-1})" -d "${DEFAULT_ETHERNET}")

#/**
# * Default shared folders is setup with active user and box name
# */
DEFAULT_HOST_SHARED_FOLDER=$(echo "$(get_parameter 'host_shared_folder' -f ${CONFIG_DIST})" | sed s/\`whoami\`/$(whoami)/ | sed s/\`box_name\`/${BOX_NAME}/)
HOST_SHARED_FOLDER=$(prompt_user 'host_shared_folder' -d "${DEFAULT_HOST_SHARED_FOLDER}")

DEFAULT_GUEST_SHARED_FOLDER=$(get_parameter 'guest_shared_folder' -f ${CONFIG_DIST})
GUEST_SHARED_FOLDER=$(prompt_user 'guest_shared_folder' -d "${DEFAULT_GUEST_SHARED_FOLDER}")

DEFAULT_NFS_SHARE=$(get_parameter 'nfs_share' -f ${CONFIG_DIST})
NFS_SHARE=$(prompt_user 'nfs_share' -b -d "${DEFAULT_NFS_SHARE}")

#/**
# * provisionnig
# */
echo_info 'Note: String valid for one provisonner, use array syntax for more'
DEFAULT_PROVISIONS="$(get_parameter 'provisions' -f ${CONFIG_DIST})"
PROVISIONS=$(prompt_user 'provisions' -d "${DEFAULT_PROVISIONS}")

# Create default shared folder in user home folder
if [ ! -d "${HOST_SHARED_FOLDER}" ]; then
    echo_info 'Create default shared folder in user home'
    echo_info "mkdir -p \"${HOST_SHARED_FOLDER}\""
    mkdir -p "${HOST_SHARED_FOLDER}"
fi

cat >> ${CONFIG} << EOL
${BOX_NAME}:
    box_name:            ${BOX_NAME}
    box_type:            ${BOX_TYPE}
    show_gui:            ${SHOW_GUI}
    video_memory_mo:     ${VIDEO_MEMORY_MO}
    disk_size:           ${DISK_SIZE}
    memory_limit_mo:     ${MEMORY_LIMIT_MO}
    cpu_number:          ${CPU_NUMBER}
    host_only_ip:        ${HOST_ONLY_IP}
    intnet_ip:           ${INTNET_IP}
    public_ip:           ${PUBLIC_IP}
    # detected ethernet: ${DEFAULT_ETHERNET}
    # detected wifi:     ${DEFAULT_WIFI}
    bridge:              ${BRIDGE}
    host_shared_folder:  ${HOST_SHARED_FOLDER}
    guest_shared_folder: ${GUEST_SHARED_FOLDER}
    nfs_share:           ${NFS_SHARE}
    provisions:          ${PROVISIONS}
EOL

echo_caption 'This is your current config'
echo
cat ${CONFIG}
echo

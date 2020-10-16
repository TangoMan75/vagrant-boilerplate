#/**
# * TangoMan Vagrant Boilerplate
# *
# * Deploy virtual machines for development
# *
# * @version  0.3.0
# * @author   "Matthias Morin" <mat@tangoman.io>
# * @licence  MIT
# * @link     https://github.com/TangoMan75/vagrant-boilerplate
# * @link     https://www.linkedin.com/in/morinmatthias
# */

.PHONY: help start stop shell restart validate status clean up init config hosts reset update destroy install install-bin uninstall check download-win7 add-win7 download-osx add-osx

# Colors
TITLE     = \033[1;42m
CAPTION   = \033[1;44m
BOLD      = \033[1;34m
LABEL     = \033[1;32m
DANGER    = \033[31m
SUCCESS   = \033[32m
WARNING   = \033[33m
SECONDARY = \033[34m
INFO      = \033[35m
PRIMARY   = \033[36m
DEFAULT   = \033[0m
NL        = \033[0m\n

## Print this help
help:
	@printf "${TITLE} TangoMan Vagrant Boilerplate ${NL}\n"

	@printf "${CAPTION} Infos:${NL}"
	@printf "${PRIMARY} %-12s${INFO} %s${NL}"   "login"  $(shell whoami)
	@printf "${PRIMARY} %-12s${INFO} %s${NL}\n" "system" $(shell uname -s)

	@printf "${CAPTION} Description:${NL}"
	@printf "${WARNING} Deploy virtual machines for development${NL}\n"

	@printf "${CAPTION} Usage:${NL}"
	@printf "${WARNING} make [command] `awk -F '?' '/^[ \t]+?[a-zA-Z0-9_-]+[ \t]+?\?=/{gsub(/[ \t]+/,"");printf"%s=[%s]\n",$$1,$$1}' ${MAKEFILE_LIST}|sort|uniq|tr '\n' ' '`${NL}\n"

	@printf "${CAPTION} Config:${NL}"
	$(eval CONFIG:=$(shell awk -F '?' '/^[ \t]+?[a-zA-Z0-9_-]+[ \t]+?\?=/{gsub(/[ \t]+/,"");printf"$${PRIMARY}%-12s$${DEFAULT} $${INFO}$${%s}$${NL}\n",$$1,$$1}' ${MAKEFILE_LIST}|sort|uniq))
	@printf " ${CONFIG}\n"

	@printf "${CAPTION} Commands:${NL}"
	@awk '/^### /{printf"\n${BOLD}%s${NL}",substr($$0,5)} \
	/^[a-zA-Z0-9_-]+:/{HELP="";if(match(PREV,/^## /))HELP=substr(PREV, 4); \
		printf " ${LABEL}%-12s${DEFAULT} ${PRIMARY}%s${NL}",substr($$1,0,index($$1,":")),HELP \
	}{PREV=$$0}' ${MAKEFILE_LIST}

####################################################
### Vagrant
####################################################

## Start vagrant
start:
	@bash ./bin/host/start_vagrant.sh

## Stop vagrant
stop:
	@printf "${INFO}vagrant halt${NL}"
	@vagrant halt

## Open bash shell into guest
shell:
	@bash ./bin/host/start_vagrant.sh
	@printf "${INFO}vagrant ssh${NL}"
	@vagrant ssh

## Restart vagrant
restart:
	@printf "${INFO}vagrant halt${NL}"
	@vagrant halt
	@sleep 2
	@bash ./bin/host/start_vagrant.sh

## Validate Vagrantfile syntax
validate:
	@printf "${INFO}vagrant validate${NL}"
	@vagrant validate

## List running vagrant boxes
status:
	@printf "${INFO}vagrant global-status${NL}"
	@vagrant global-status

## Remove stale vagrant boxes
clean:
	@printf "${INFO}vagrant global-status --prune${NL}"
	@vagrant global-status --prune

####################################################
### Vagrant Guest
####################################################

## Start and ssh into vagrant guest
up:
	@bash ./bin/host/start_vagrant.sh
	@printf "${INFO}vagrant ssh${NL}"
	@vagrant ssh

## Create vagrant guest
init: config
	@printf "${INFO}git submodule update --init --recursive${NL}"
	@git submodule update --init --recursive
	-@bash ./bin/host/create_vagrant_guest.sh

## Init configuration
config:
	@bash ./bin/host/init_vagrant_config.sh
	@bash ./bin/host/set_hosts.sh

## Set local /etc/hosts
hosts:
	@bash ./bin/host/set_hosts.sh

## Rebuild vagrant guest forcing provisioners
reset: destroy
	@sleep 2
	@printf "${INFO}vagrant up --provision --destroy-on-error${NL}"
	@vagrant up --provision --destroy-on-error

## Update guest provisioners
update:
	@printf "${INFO}vagrant halt${NL}"
	@vagrant halt
	@sleep 2
	@bash ./bin/host/set_hosts.sh
	@printf "${INFO}vagrant up --provision --destroy-on-error${NL}"
	@vagrant up --provision --destroy-on-error

## Destroy guest
destroy:
	@bash ./bin/host/destroy_vagrant.sh
	@bash ./bin/host/restart_nfs.sh

####################################################
### Vagrant Host
####################################################

## Install host (Pip, Ansible, Vagrant, VirtualBox & NFS server)
install:
	@printf "${INFO}git submodule update --init --recursive${NL}"
	@git submodule update --init --recursive
	-@bash ./bin/provisions/update.sh
	-@bash ./bin/provisions/dev/install_python-pip.sh
	-@bash ./bin/provisions/devops/install_ansible.sh
	-@bash ./bin/provisions/devops/install_vagrant.sh
	-@bash ./bin/provisions/devops/install_vagrant_plugins.sh
	-@bash ./bin/provisions/devops/install_virtualbox.sh
	-@bash ./bin/provisions/servers/install_nfs-server.sh
	-@bash ./bin/tools/check_install.sh

## Install host (Vagrant & VirtualBox)
min-install:
	-@bash ./bin/provisions/update.sh
	-@bash ./bin/provisions/devops/install_vagrant.sh
	-@bash ./bin/provisions/devops/install_vagrant_plugins.sh
	-@bash ./bin/provisions/devops/install_virtualbox.sh
	-@bash ./bin/tools/check_install.sh

## Uninstall all
uninstall:
	@bash ./bin/host/uninstall_host.sh

## Check installation
check:
	@bash ./bin/tools/check_install.sh

####################################################
### Vagrant Images
####################################################

## Download Windows7 image from microsoft
download-win7:
	@printf "${INFO}wget https://az792536.vo.msecnd.net/vms/VMBuild_20150916/Vagrant/IE8/IE8.Win7.Vagrant.zip${NL}"
	@wget https://az792536.vo.msecnd.net/vms/VMBuild_20150916/Vagrant/IE8/IE8.Win7.Vagrant.zip
	-@make add-win7

## Extract and add downloaded Windows7 image from microsoft
add-win7:
	@printf "${INFO}7z e IE8.Win7.Vagrant.zip${NL}"
	@7z e IE8.Win7.Vagrant.zip
	@printf "${INFO}rm IE8.Win7.Vagrant.zip${NL}"
	@rm IE8.Win7.Vagrant.zip
	@printf "${INFO}vagrant box add win7 "./IE8 - Win7.box"${NL}"
	@vagrant box add win7 "./IE8 - Win7.box"

## Download Mac OSX image from Vagrant
download-osx:
	@printf "${INFO}wget https://vagrant-osx.nyc3.digitaloceanspaces.com/osx-sierra-0.3.1.box${NL}"
	@wget https://vagrant-osx.nyc3.digitaloceanspaces.com/osx-sierra-0.3.1.box
	-@make add-osx

## Extract and add downloaded OSX image from Apple
add-osx:
	@printf "${INFO}vagrant box add osx ./osx-sierra-0.3.1.box${NL}"
	@vagrant box add osx ./osx-sierra-0.3.1.box


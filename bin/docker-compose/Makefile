#/**
# * TangoMan Ghost Docker Compose
# *
# * Deploy a Ghost app with docker-compose
# *
# * @version  0.2.0
# * @author   "Matthias Morin" <mat@tangoman.io>
# * @licence  MIT
# * @link     https://gist.github.com/TangoMan75/6472dbdb64ec04ddb5108c3356600a84
# * @link     https://www.linkedin.com/in/morinmatthias
# */

.PHONY: help c-start c-status c-logs c-stop c-kill c-clean c-valid c-install c-remove top stop-all kill-all clean remove-all 

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

# Host network config
default_ethernet="$(shell ip token | cut -d\  -f4 | grep -E '^e' | head -n1)"
default_wifi="$(shell ip token | cut -d\  -f4 | grep -E '^w' | head -n1)"

adapter?=${default_ethernet}
# valid parameter = bridge, host, macvlan or none
network?=bridge

## Print this help
help:
	@printf "${TITLE} TangoMan Ghost Docker Compose ${container} ${NL}"

	@printf "${CAPTION} Infos:${NL}"
	@printf "${PRIMARY} %-12s${INFO} %s${NL}"   "ethernet"  ${default_ethernet}
	@printf "${PRIMARY} %-12s${INFO} %s${NL}\n" "wifi"      ${default_wifi}

	@printf "${CAPTION} Description:${NL}"
	@printf "${WARNING} Deploy a Ghost app with docker-compose${NL}\n"

	@printf "${CAPTION} Usage:${NL}"
	@printf "${WARNING} make [command] `awk -F '?' '/^[ \t]+?[a-zA-Z0-9_-]+[ \t]+?\?=/{gsub(/[ \t]+/,"");printf"%s=[%s]\n",$$1,$$1}' ${MAKEFILE_LIST}|sort|uniq|tr '\n' ' '`${NL}\n"

	@printf "${CAPTION} Config:${NL}"
	$(eval CONFIG:=$(shell awk -F '?' '/^[ \t]+?[a-zA-Z0-9_-]+[ \t]+?\?=/{gsub(/[ \t]+/,"");printf"$${PRIMARY}%-12s $${INFO}$${%s}$${NL}\n",$$1,$$1}' ${MAKEFILE_LIST}|sort|uniq))
	@printf " ${CONFIG}\n"

	@printf "${CAPTION} Commands:${NL}"
	@awk '/^### /{printf"\n${BOLD}%s${NL}",substr($$0,5)} \
	/^[a-zA-Z0-9_-]+:/{HELP="";if(match(PREV,/^## /))HELP=substr(PREV, 4); \
		printf " ${LABEL}%-12s${DEFAULT} ${PRIMARY}%s${NL}",substr($$1,0,index($$1,":")),HELP \
	}{PREV=$$0}' ${MAKEFILE_LIST}

##################################################
### docker-compose
##################################################

## Start stack
c-start:
	@printf "${INFO}docker-compose up --detach${NL}"
	@docker-compose up --detach

## Stack status
c-status:
	@printf "${INFO}docker-compose ps${NL}"
	@docker-compose ps

## Show stack logs
c-logs:
	@printf "${INFO}docker-compose logs -f --tail 5${NL}"
	@docker-compose logs -f --tail 5

## Stop docker stack
c-stop:
	@printf "${INFO}docker-compose stop${NL}"
	@docker-compose stop

## Kill docker stack
c-kill:
	@printf "${INFO}docker-compose kill${NL}"
	@docker-compose kill

## Stop and remove containers, networks, volumes, and images
c-clean:
	@printf "${INFO}docker-compose down --remove-orphans${NL}"
	@docker-compose down --remove-orphans

## Check docker-compose.yaml syntax validity
c-valid:
	@printf "${INFO}docker-compose config${NL}"
	@docker-compose config

##################################################
### Docker Manager
##################################################

## List images, volumes and network information
top:
	@printf "${INFO}docker ps --all${NL}"
	@docker ps --all
	@printf "${INFO}docker images --all${NL}"
	@docker images --all
	@printf "${INFO}docker volume ls${NL}"
	@docker volume ls
	@printf "${INFO}docker network ls${NL}"
	@docker network ls
	@printf "${INFO}docker inspect --format '{{ .Name }}: {{ .NetworkSettings.IPAddress }}' `docker ps --quiet | tr '\n' ' '` 2>/dev/null${NL}"
	@docker inspect --format '{{ .Name }}: {{ .NetworkSettings.IPAddress }}' `docker ps --quiet | tr '\n' ' '` 2>/dev/null

## Stop all running containers
stop-all:
	@printf "${INFO}docker stop `docker ps --quiet`${NL}"
	@docker stop `docker ps --quiet`

## Kill all running containers
kill-all:
	@printf "${INFO}docker kill `docker ps --quiet | tr '\n' ' '` 2>/dev/null${NL}"
	@docker kill `docker ps --quiet | tr '\n' ' '` 2>/dev/null
	@printf "${INFO}docker rm `docker ps --all --quiet | tr '\n' ' '` 2>/dev/null${NL}"
	@docker rm `docker ps --all --quiet | tr '\n' ' '` 2>/dev/null

## Remove all unused system, images, containers, volumes and networks
clean:
	@printf "${INFO}docker system prune --force${NL}"
	@docker system prune --force
	@printf "${INFO}docker image prune --all --force${NL}"
	@docker image prune --all --force
	@printf "${INFO}docker container prune --force${NL}"
	@docker container prune --force
	@printf "${INFO}docker volume prune --force${NL}"
	@docker volume prune --force
	@printf "${INFO}docker network prune --force${NL}"
	@docker network prune --force

## Kill and remove all system, images, containers, volumes and networks
remove-all:
	-@make -s kill-all
	-@make -s clean

##################################################
### Docker Compose Install Host
##################################################

## Install docker-compose locally
c-install:
ifeq (${SYSTEM},Linux)
	@#curl -L => follow redirects
	@printf "${INFO}sudo curl -L \"https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m`\" -o /usr/bin/docker-compose${NL}"
	@sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m`" -o /usr/bin/docker-compose
	@printf "${INFO}sudo chmod +x /usr/bin/docker-compose${NL}"
	@sudo chmod +x /usr/bin/docker-compose
endif

## Remove docker-compose
c-remove:
ifeq (${SYSTEM},Linux)
	@printf "${INFO}sudo rm -f /usr/bin/docker-compose${NL}"
	@sudo rm -f /usr/bin/docker-compose
endif


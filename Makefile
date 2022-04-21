################################################################################
#                                                                              #
#              Variables Makefile                                              #
#                                                                              #
################################################################################
NAME=				inception
SRCS=				srcs/
ENV_FILE=			${SRCS}.env
ENTRYPOINT_TIER=	inception_entrypoint-tier
FRONT_TIER=			inception_front-tier
BACK_TIER=			inception_back-tier
VOLUMES=			${HOME}/data/
VOL_CONT_FRONT=		/var/www/data
VOL_CONT_BACK=		/bdd/
VOL_HOTE_FRONT=		${VOLUMES}front-vol/
VOL_HOTE_BACK=		${VOLUMES}back-vol/
NGINX=				${SRCS}nginx/
MARIADB=			${SRCS}mariadb/
TOOLS=				${SRCS}${SERVICE}/tools/
WP=					${SRCS}wordpress/
TAG=				${NAME}


################################################################################
#                                                                              #
#              Cmds SHELL                                                      #
#                                                                              #
################################################################################

MAKE=				make -s -i --no-print-directory
RM=					rm -rf
ECHO=				printf

################################################################################
#                                                                              #
#              Cmds DOCKER                                                     #
#                                                                              #
################################################################################

BUILD=				docker image build -t ${SERVICE} ./${SRCS}${SERVICE}/
RMI=				docker image rm ${SERVICE}:${TAG}
RUN=				docker container run -p ${PORT_HOTE}:${PORT_CONTAINER} -v ${VOL_HOTE}:${VOL_CONT} --name=${SERVICE} -itd ${SERVICE}
START=				docker container start ${SERVICE} 
STOP=				docker container stop ${SERVICE} 
RMC=				docker container rm ${SERVICE}
EXEC_DEBUG=			docker exec -it ${SERVICE} /bin/bash
PRUNE=				docker system prune -a --volumes
LS_CONT=			docker container ls -a
LS_IMG=				docker image ls -a

UP=					docker compose --env-file ${ENV_FILE} --profile ${PROFILE} up -d
DOWN=				docker compose down
#COMPOSE_BUILD=		docker compose build --no-cache ${SERVICE}
COMPOSE_BUILD=		docker compose --env-file ${ENV_FILE} --profile ${PROFILE} build ${SERVICE}
#COMPOSE_RUN=		docker compose --env-file ${ENV_FILE} --profile ${PROFILE} run -p ${PORT_HOTE}:${PORT_CONTAINER} -v ${VOL_HOTE}:${VOL_CONT} --name=${SERVICE} -itd ${SERVICE}
COMPOSE_RUN=		docker compose run -p ${PORT_HOTE}:${PORT_CONTAINER} -v ${VOL_HOTE}:${VOL_CONT} --name=${SERVICE} -itd ${SERVICE}
COMPOSE_START=		docker compose start ${SERVICE}
COMPOSE_STOP=		docker compose stop ${SERVICE}
COMPOSE_RMC=		docker compose rm -v ${SERVICE}
COMPOSE_EXEC=		docker compose exec -it ${SERVICE} /bin/bash
#COMPOSE_EXEC=		docker compose --env-file ${ENV_FILE} exec -it ${SERVICE} /bin/bash
CLEAN_NETWORK=		docker network rm ${NETWORK}
CLEAN_VOL_FRONT=	docker volume rm front-vol
CLEAN_VOL_BACK=		docker volume rm back-vol

################################################################################
#                                                                              #
#              rules Makefile                                                  #
#                                                                              #
################################################################################

test: ${NAME}
	make docker-fclean

mandatory:
	make mandatory-intrm PROFILE=mandatory

mandatory-intrm:
	${UP}

mandatory-clean:
	${DOWN} && ${CLEAN_VOL_FRONT}

${NAME}: nginx mariadb wordpress

.PHONY: nginx nginx-intrm nginx-clean nginx-clean-intrm

nginx:
	make nginx-intrm SERVICE=nginx PORT_CONTAINER=443 PORT_HOTE=443 VOL_HOTE=${VOL_HOTE_FRONT} VOL_CONT=${VOL_CONT_FRONT} PROFILE=mandatory

nginx-intrm:
	if ! [[ -a ${VOLUMES}front-vol ]]; then mkdir -p ${VOLUMES}front-vol; fi
	${COMPOSE_BUILD} && ${COMPOSE_RUN}
#	&& ${COMPOSE_EXEC}
#	${BUILD} && ${RUN} && ${START} && ${EXEC_DEBUG}

nginx-clean:
	make nginx-clean-intrm SERVICE=nginx NETWORK=${ENTRYPOINT_TIER}

nginx-clean-intrm:
	${COMPOSE_STOP} && ${COMPOSE_RMC} && ${RMI}
	${CLEAN_VOL_FRONT}
	${CLEAN_NETWORK}
#	${STOP} && ${RMC} && ${RMI}
#	if [[ -a ${VOLUMES}front-vol ]]; then rm -rf ${VOLUMES}front-vol; fi

.PHONY: mariadb mariadb-intrm mariadb-clean mariadb-clean-intrm

mariadb:
	make mariadb-intrm SERVICE=mariadb PORT_CONTAINER=3306 PORT_HOTE=3306 VOL_HOTE=${VOL_HOTE_BACK} VOL_CONT=${VOL_CONT_BACK}

mariadb-intrm:
	if ! [[ -a ${VOLUMES}back-vol ]]; then mkdir -p ${VOLUMES}back-vol; fi
	${BUILD} && ${RUN}
	echo ${TOOLS}; echo ${SERVICE} ${PORT_HOTE} ${PORT_CONTAINER} ${VOLUMES}

mariadb-clean:
	make mariadb-clean-intrm SERVICE=mariadb

mariadb-clean-intrm:
	${STOP} && ${RMC} && ${RMI}
#	if [[ -a ${VOLUMES}back-vol ]]; then rm -rf ${VOLUMES}back-vol; fi

.PHONY: wordpress wordpress-intrm wordpress-clean wordpress-clean-intrm

wordpress:
	make wordpress-intrm SERVICE=wordpress PORT_CONTAINER=9000 PORT_HOTE=9000 VOL_HOTE=${VOL_HOTE_FRONT} VOL_CONT=${VOL_CONT_FRONT}

wordpress-intrm:
	if ! [[ -a ${VOLUMES}front-vol ]]; then mkdir -p ${VOLUMES}front-vol; fi
	${BUILD} && ${RUN}
	echo ${TOOLS}; echo ${SERVICE} ${PORT_HOTE} ${PORT_CONTAINER} ${VOLUMES}

wordpress-clean:
	make wordpress-clean-intrm SERVICE=wordpress

wordpress-clean-intrm:
	${STOP} && ${RMC} && ${RMI}
#	if [[ -a ${VOLUMES}front-vol ]]; then rm -rf ${VOLUMES}front-vol; fi

.PHONY: ${NAME} docker-fclean check clean

check:
	${LS_CONT}
	${LS_IMG}

docker-fclean: nginx-clean mariadb-clean wordpress-clean
	${PRUNE}
#	${RM} ${VOLUMES}

clean:
	${PRUNE}
#	${RM} ${VOLUMES}
#
#
#
#	docker-compose config -> check la config .yml du container

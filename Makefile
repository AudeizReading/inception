################################################################################
#                                                                              #
#              Variables Makefile                                              #
#                                                                              #
################################################################################
NAME=				inception
SRCS=				srcs/
ENV_FILE=			.env
ENTRYPOINT_TIER=	inception_entrypoint-tier
FRONT_TIER=			inception_front-tier
BACK_TIER=			inception_back-tier
VOLUMES=			${HOME}/data/
VOL_CONT_FRONT=		/var/www/
VOL_CONT_BACK=		/var/lib/mysql/
VOL_HOTE_FRONT=		${VOLUMES}front-vol/
VOL_HOTE_BACK=		${VOLUMES}back-vol/
NGINX=				./${SRCS}nginx/
MARIADB=			./${SRCS}mariadb/
TOOLS=				./${SRCS}${SERVICE}/tools/
WP=					./${SRCS}wordpress/
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

BUILD=				docker image build -t ${SERVICE} ./${SERVICE}/
RMI=				docker image rm ${SERVICE}:${TAG}
RUN=				docker container run -p ${PORT_HOTE}:${PORT_CONTAINER} -v ${VOL_HOTE}:${VOL_CONT} --name=${SERVICE} -itd ${SERVICE}
START=				docker container start ${SERVICE} 
STOP=				docker container stop ${SERVICE} 
RMC=				docker container rm ${SERVICE}
EXEC_DEBUG=			docker exec -it ${SERVICE} /bin/bash

UP=					docker-compose up -d
DOWN=				docker-compose down
COMPOSE_BUILD=		docker-compose --verbose build ${SERVICE}
COMPOSE_RUN=		docker-compose run -p ${PORT_HOTE}:${PORT_CONTAINER} --name=${SERVICE} -d ${SERVICE}
COMPOSE_START=		docker-compose start ${SERVICE}
COMPOSE_STOP=		docker-compose stop ${SERVICE}
COMPOSE_RMC=		docker-compose rm -v ${SERVICE}
COMPOSE_EXEC=		docker-compose exec -it ${SERVICE} /bin/bash

CLEAN_NETWORK=		docker network rm ${NETWORK}
CLEAN_VOL_FRONT=	docker volume rm front-vol
CLEAN_VOL_BACK=		docker volume rm back-vol
LS_CONT=			docker container ls -a
LS_IMG=				docker image ls -a
LS_VOL=				docker volume ls
LS_NET=				docker network ls
PRUNE=				docker system prune -a --volumes

################################################################################
#                                                                              #
#              rules Makefile                                                  #
#                                                                              #
################################################################################


.PHONY: ${NAME}

${NAME}: nginx

.PHONY: nginx nginx-intrm nginx-clean nginx-clean-intrm

nginx:
	make nginx-intrm SERVICE=$@ PORT_CONTAINER=443 PORT_HOTE=443

nginx-intrm:
# if the volume does not yet exist, we must create it otherwise docker triggers
# an error
	if [ ! -f ${VOLUMES}front-vol ]; then mkdir -m 777 -p ${VOLUMES}front-vol; fi
	if [ ! -f ${VOLUMES}back-vol ]; then mkdir -m 777 -p ${VOLUMES}back-vol; fi
	cd ${SRCS} && ${COMPOSE_BUILD} && ${COMPOSE_RUN}
#	cd ${SRCS} && ${COMPOSE_RUN}

nginx-clean:
	make nginx-clean-intrm SERVICE=nginx

nginx-clean-intrm:
	cd ${SRCS} && ${DOWN} 
	${CLEAN_VOL_FRONT}
	${CLEAN_VOL_BACK}
	${RMI}

.PHONY: ${NAME} fclean check clean re

check:
	${LS_CONT}
	${LS_IMG}
	${LS_VOL}
	${LS_NET}

clean:
	cd ${SRCS} && ${DOWN}

fclean: clean
	${CLEAN_VOL_FRONT}
	${CLEAN_VOL_BACK}
	docker image rm `${LS_IMG} -q` 2> /dev/null
	${PRUNE}

re: fclean all
#
#
#
#	docker-compose config -> check la config .yml du container

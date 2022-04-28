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
VOL_CONT_BACK=		/bdd/
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
#COMPOSE_BUILD=		docker-compose build ${SERVICE}
COMPOSE_RUN=		docker-compose run -p ${PORT_HOTE}:${PORT_CONTAINER} --name=${SERVICE} -d ${SERVICE}
#COMPOSE_RUN=		docker-compose run -p ${PORT_HOTE}:${PORT_CONTAINER} -v ${VOL_HOTE}:${VOL_CONT} --name=${SERVICE} -d ${SERVICE}
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

${NAME}: nginx mariadb wordpress

.PHONY: nginx nginx-intrm nginx-clean nginx-clean-intrm

nginx:
#	make wordpress  
#	make nginx-intrm SERVICE=nginx PORT_CONTAINER=443 PORT_HOTE=443 VOL_HOTE=${VOL_HOTE_FRONT} VOL_CONT=${VOL_CONT_FRONT} 
	make nginx-intrm SERVICE=nginx PORT_CONTAINER=443 PORT_HOTE=443 VOL_HOTE=${VOL_HOTE_FRONT} VOL_CONT=${VOL_CONT_FRONT} 

nginx-intrm:
# if the volume does not yet exist, we must create it otherwise docker triggers
# an error
	if [ ! -f ${VOLUMES}front-vol ]; then mkdir -m 777 -p ${VOLUMES}front-vol; fi
	if [ ! -f ${VOLUMES}back-vol ]; then mkdir -m 777 -p ${VOLUMES}back-vol; fi
	cd ${SRCS} && ${COMPOSE_BUILD} 
	cd ${SRCS} && ${COMPOSE_RUN}
#	&& ${COMPOSE_EXEC}

nginx-clean:
	make nginx-clean-intrm SERVICE=nginx NETWORK=${ENTRYPOINT_TIER}

nginx-clean-intrm:
	cd ${SRCS} && ${DOWN} 
	${CLEAN_VOL_FRONT}
#	${CLEAN_NETWORK}
	${RMI} 

.PHONY: mariadb mariadb-intrm mariadb-clean mariadb-clean-intrm

mariadb:
	make mariadb-intrm SERVICE=mariadb PORT_CONTAINER=3306 PORT_HOTE=3306 VOL_HOTE=${VOL_HOTE_BACK} VOL_CONT=${VOL_CONT_BACK}

mariadb-intrm:
	if ! [[ -a ${VOLUMES}back-vol ]]; then mkdir -m 777 -p ${VOLUMES}back-vol; fi
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
#	if [ ! -f ${VOLUMES}front-vol ]; then mkdir -p ${VOLUMES}front-vol; fi
	cd ${SRCS} && ${COMPOSE_BUILD} 
	cd ${SRCS} && ${COMPOSE_RUN}
#	cd ${SRCS} && ${COMPOSE_EXEC}

wordpress-clean:
	make wordpress-clean-intrm SERVICE=wordpress

wordpress-clean-intrm:
	cd ${SRCS} && ${DOWN} 
#	${CLEAN_VOL_FRONT}
	${RMI} 
#	if [[ -a ${VOLUMES}front-vol ]]; then rm -rf ${VOLUMES}front-vol; fi

.PHONY: ${NAME} docker-fclean check clean

check:
	${LS_CONT}
	${LS_IMG}
	${LS_VOL}
	${LS_NET}

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

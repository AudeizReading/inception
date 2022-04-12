################################################################################
#                                                                              #
#              Variables Makefile                                              #
#                                                                              #
################################################################################
NAME=				inception
SRCS=				srcs/
VOLUMES=			/${HOME}/${USER}/data/
NGINX=				$(SRCS)nginx/
MARIADB=			$(SRCS)mariadb/
TOOLS=				$(SRCS)$(SERVICE)/tools/
WP=					$(SRCS)wordpress/


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

BUILD=				docker image build -t $(SERVICE) ./${SRCS}${SERVICE}/
RMI=				docker image rm $(SERVICE)
# RUN -> Y a peut - etre des volumes a monter ? -v ${VOLUMES}wordpress:/usr/share/nginx/html
RUN=				docker container run -p $(PORT_HOTE):$(PORT_CONTAINER) --name=$(SERVICE) -d $(SERVICE)
START=				docker container start $(SERVICE) 
STOP=				docker container stop $(SERVICE) 
RMC=				docker container rm $(SERVICE)
PRUNE=				docker system prune -a --volumes
LS_CONT=			docker container ls -a
LS_IMG=				docker image ls -a

################################################################################
#                                                                              #
#              rules Makefile                                                  #
#                                                                              #
################################################################################

test: ${NAME}
	make docker-fclean

${NAME}: nginx mariadb wordpress

.PHONY: nginx nginx-intrm nginx-clean nginx-clean-intrm

nginx:
	make nginx-intrm SERVICE=nginx PORT_CONTAINER=443 PORT_HOTE=4430

nginx-intrm:
	if ! [[ -a ${VOLUMES}wordpress ]]; then mkdir -p ${VOLUMES}wordpress; fi
	${BUILD} && ${RUN}
	echo $(TOOLS); echo ${SERVICE} ${PORT_HOTE} ${PORT_CONTAINER} ${VOLUMES}

nginx-clean:
	make nginx-clean-intrm SERVICE=nginx

nginx-clean-intrm:
	${STOP} && ${RMC} && ${RMI}
	if [[ -a ${VOLUMES}wordpress ]]; then rm -rf ${VOLUMES}wordpress; fi

.PHONY: mariadb mariadb-intrm mariadb-clean mariadb-clean-intrm

mariadb:
	make mariadb-intrm SERVICE=mariadb PORT_CONTAINER=443 PORT_HOTE=4430

mariadb-intrm:
	if ! [[ -a ${VOLUMES}mariadb ]]; then mkdir -p ${VOLUMES}mariadb; fi
	${BUILD} && ${RUN}
	echo $(TOOLS); echo ${SERVICE} ${PORT_HOTE} ${PORT_CONTAINER} ${VOLUMES}

mariadb-clean:
	make mariadb-clean-intrm SERVICE=mariadb

mariadb-clean-intrm:
	${STOP} && ${RMC} && ${RMI}
	if [[ -a ${VOLUMES}mariadb ]]; then rm -rf ${VOLUMES}mariadb; fi

.PHONY: wordpress wordpress-intrm wordpress-clean wordpress-clean-intrm

wordpress:
	make wordpress-intrm SERVICE=wordpress PORT_CONTAINER=443 PORT_HOTE=4430

wordpress-intrm:
	if ! [[ -a ${VOLUMES}wordpress ]]; then mkdir -p ${VOLUMES}wordpress; fi
	${BUILD} && ${RUN}
	echo $(TOOLS); echo ${SERVICE} ${PORT_HOTE} ${PORT_CONTAINER} ${VOLUMES}

wordpress-clean:
	make wordpress-clean-intrm SERVICE=wordpress

wordpress-clean-intrm:
	${STOP} && ${RMC} && ${RMI}
	if [[ -a ${VOLUMES}wordpress ]]; then rm -rf ${VOLUMES}wordpress; fi

.PHONY: ${NAME} docker-clean check

check:
	${LS_CONT}
	${LS_IMG}

docker-fclean: nginx-clean mariadb-clean wordpress-clean
	${PRUNE}

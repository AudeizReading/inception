################################################################################
#                                                                              #
#              Variables Makefile                                              #
#                                                                              #
################################################################################
NAME=				inception
SRCS=				srcs/
VOLUMES=			/home/alellouc/data
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
RUN=				docker container run -p $(PORT_HOTE):$(PORT_CONTAINER) --name=$(SERVICE) -d $(SERVICE)
START=				docker container start $(SERVICE) 
STOP=				docker container stop $(SERVICE) 
RMC=				docker container rm $(SERVICE)
PRUNE=				docker system prune -a --volumes

PORT_HOTE=
PORT_CONTAINER=

################################################################################
#                                                                              #
#              rules Makefile                                                  #
#                                                                              #
################################################################################

.PHONY: nginx nginx-intrm

nginx:
	make nginx-intrm SERVICE=nginx PORT_CONTAINER=4430 PORT_HOTE=443

nginx-intrm:
	${BUILD} && ${RUN}
	echo $(TOOLS); echo ${SERVICE} ${PORT_HOTE} ${PORT_CONTAINER}

nginx-clean:
	make nginx-clean-intrm SERVICE=nginx

nginx-clean-intrm:
	${STOP} && ${RMC} && ${RMI}

docker-fclean:
	${PRUNE}

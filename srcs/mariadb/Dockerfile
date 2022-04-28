# nginx Dockerfile
FROM	debian:buster

ARG		MAINTAINER

LABEL	maintainer $MAINTAINER

RUN		apt-get update -y && apt-get install -y mariadb-server

CMD		mariadb	

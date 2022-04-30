# nginx Dockerfile
FROM	debian:buster

ARG		MAINTAINER

LABEL	maintainer $MAINTAINER

RUN		apt-get update -y && apt-get install -y cron mariadb-server
RUN		echo "* * * * * root /usr/bin/echo \"Hello 42 World !\n\" >> /dev/null" > /etc/cron.d/backend

#CMD		mariadb	
CMD /usr/sbin/cron -f

# nginx Dockerfile
FROM	debian:buster

ARG		MAINTAINER
ARG		MYSQL_ROOT_PW
ARG		MYSQL_USER
ARG		MYSQL_PW

LABEL	maintainer $MAINTAINER

RUN		apt-get update -y && apt-get install -y curl cron
RUN		curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | bash
RUN		apt-get update -y && apt-get install -y mariadb-server galera-4 mariadb-client libmariadb3 mariadb-backup mariadb-common
RUN		echo "* * * * * root /usr/bin/echo \"Hello 42 World !\n\" >> /dev/null" > /etc/cron.d/backend

#CMD		mariadb	
CMD /usr/sbin/cron -f

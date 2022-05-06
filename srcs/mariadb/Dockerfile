# mariadb Dockerfile
FROM	debian:buster

ARG		MAINTAINER
ARG     INCEPTION_DB
ARG     INCEPTION_ADMIN
ARG     INCEPTION_ADMIN_PW
ARG     INCEPTION_EDITOR
ARG     INCEPTION_EDITOR_PW

LABEL	maintainer $MAINTAINER

RUN		apt-get update -y && apt-get install -y perl curl 
RUN		curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | bash
RUN		apt-get update -y && apt-get install -y mariadb-server \
		mariadb-client \
		libmariadb3 \
		mariadb-backup \
		mariadb-common
COPY	/conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY	/tools/docker-entrypoint.sh /usr/local/bin/

# very important step, without that it cannot connect mysql socket, we need to
# create the dirs /run/mysqld and /var
RUN		mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld/ \
		&& rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql \
		&& chown -R mysql:mysql /var/lib/mysql

ENTRYPOINT ["docker-entrypoint.sh"]
CMD		["mysqld"]

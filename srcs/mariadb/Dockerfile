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
#COPY	/conf/my.cnf.a.update /etc/mysql/my.cnf
COPY	/conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY	/tools/docker-entrypoint.sh /usr/local/bin/
#RUN sed -Ei 's/^(bind-address|log)/#&/' /etc/mysql/my.cnf
ENTRYPOINT ["docker-entrypoint.sh"]
#RUN		mkdir -p /run/mysqld
#RUN		echo "* * * * * root /usr/bin/echo \"Hello 42 World !\n\" >> /dev/null" > /etc/cron.d/backend

#RUN			service mariadb start
#RUN		mariadb.server start
#
#RUN		echo "CREATE DATABASE $DB_WP;" | mysql
#RUN		echo "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PW}';" | mysql
#RUN		echo "GRANT ALL PRIVILEGES ON $DB_WP . * TO '${MYSQL_USER}'@'%';" | mysql
#RUN		echo "FLUSH PRIVILEGES;" | mysql
#CMD		/usr/sbin/cron -f
EXPOSE	3306
CMD		["mysqld"]

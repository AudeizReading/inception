# nginx Dockerfile
FROM	debian:buster

ARG		MAINTAINER
ARG		MYSQL_ROOT_PW
ARG		MYSQL_USER
ARG		MYSQL_PW

LABEL	maintainer $MAINTAINER

RUN		apt-get update -y && apt-get install -y perl curl cron
#RUN		apt-get update -y && apt-get install -y curl 
RUN		curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | bash
RUN		apt-get update -y && apt-get install -y mariadb-server galera-4 mariadb-client libmariadb3 mariadb-backup mariadb-common
COPY	/conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY	/tools/docker-entrypoint.sh /usr/local/bin/

# very important step, without that it cannot connect mysql socket
RUN		mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld/ && rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql
#RUN		echo "* * * * * root /usr/bin/echo \"Hello 42 World !\n\" >> /dev/null" > /etc/cron.d/backend

#CMD		/usr/sbin/cron -f
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE	3306
CMD		["mysqld"]

# nginx Dockerfile

# As allowed, taking the debian:buster image already existing
# I do not know how to build an OS like this without this option, maybe by
# looking at the Dockerfile of the debian image, but I only doubt that is the
# purpoose of the subject
FROM	debian:buster

ARG		MAINTAINER
ARG		SSL_PATH
ARG		FQDN

LABEL	maintainer $MAINTAINER

# Downloading nginx packages et set config for nginx user
# Forwarding stdout and stderr to nginx's corresponding logfile
RUN		addgroup --system --gid 101 nginx \
		&& adduser --system --disabled-login --ingroup nginx --no-create-home \
			--home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx \
		&& apt-get update -y && apt-get upgrade -y \
		&& apt-get install -y -q nginx-full ca-certificates openssl \
		&& ln -sf /dev/stdout /var/log/nginx/access.log \
		&& ln -sf /dev/stderr /var/log/nginx/error.log

# Copying script and config for generating ssl key. Run the script before
# deleting it (no more need)
COPY	/tools/gen-ssl-certs.sh /tmp/gen-ssl-certs.sh
COPY	/conf/ca-ssl.cnf /tmp/ca-ssl.cnf
RUN		cd /tmp && ./gen-ssl-certs.sh $SSL_PATH ./ca-ssl.cnf $FQDN && rm -rf ./gen-ssl-certs.sh

# Copying config files needed for the well nginx running
# Intercepts 443 traffic
COPY	/conf/nginx.conf /etc/nginx/nginx.conf
COPY	/conf/html.conf /tmp/html.conf
COPY	/conf/index.html /var/www/html/index.html

RUN		mkdir -p /var/www/data/nginx/conf/conf.d \
		&& mv /tmp/html.conf /var/www/data/nginx/conf/conf.d/html.conf

ENTRYPOINT	["nginx"]
CMD			["-g", "daemon off;"]

STOPSIGNAL	SIGQUIT

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
#RUN		addgroup --system --gid 101 nginx \
#		&& adduser --system --disabled-login --ingroup nginx --no-create-home \
#			--home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx \
#		&& apt-get update -y && apt-get upgrade -y \
#		&& apt-get install -y -q nginx-full ca-certificates openssl \
#		&& ln -sf /dev/stdout /var/log/nginx/access.log \
RUN		apt-get update -y && apt-get upgrade -y \
		&& apt-get install -y -q nginx-full ca-certificates openssl

# Copying script and config for generating ssl key. Run the script before
# deleting it (no more need)
COPY	/tools/gen-ssl-certs.sh /tmp/gen-ssl-certs.sh
COPY	/conf/ca-ssl.cnf /tmp/ca-ssl.cnf
RUN		cd /tmp && ./gen-ssl-certs.sh $SSL_PATH ./ca-ssl.cnf $FQDN && rm -rf ./gen-ssl-certs.sh

# Copying config files needed for the well nginx running
# Intercepts 443 traffic
COPY	/conf/nginx.conf			/etc/nginx/nginx.conf
COPY	/conf/alellouc.42.fr.conf	/etc/nginx/conf.d/alellouc.42.fr.conf

#RUN		mkdir -p /var/www/alellouc.42.fr/cache 
COPY	--chown=www-data:www-data	/conf/index.php				/var/www/alellouc.42.fr/index.php
COPY	--chown=www-data:www-data	/conf/index.html /var/www/alellouc.42.fr/index.html


#RUN	
#COPY	/conf/html.conf /tmp/html.conf
#COPY	/conf/index.php /var/www/html/index.php

#RUN		mkdir -p /var/www/data/nginx/conf/conf.d \
		#&& mv /tmp/html.conf /var/www/data/nginx/conf/conf.d/html.conf

# Testing php
RUN		apt-get update -y && apt-get upgrade -y \
		&& apt-get install -y curl apt-transport-https lsb-release \
		ca-certificates \
		&& curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg \
		https://packages.sury.org/php/apt.gpg \
		&& sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' \
		&& apt-get update -y \
		&& apt-get install -y php8.1 \
		php8.1-bcmath \
		php8.1-fpm \
		php8.1-xml \
		php8.1-mysql \
		php8.1-common \
		php8.1-snmp \
		php-json \
		php8.1-intl \
		php8.1-zip \
		php8.1-intl \
		php8.1-ldap \
		php8.1-gd \
		php8.1-cli \
		php8.1-bz \
		php8.1-curl \
		php8.1-mbstring \
		php8.1-pgsql \
		php8.1-opcache \
		php8.1-soap \
		php8.1-cgi \
		&& mkdir -p /var/run/php
#COPY	/conf/test/php.ini /etc/php/8.1/fpm/php.ini
#COPY	/conf/test/www.conf /etc/php/8.1/fpm/pool.d/www.conf
#RUN		mv /tmp/nginx-php-fpm.conf /var/www/data/nginx/conf/conf.d/nginx-php-fpm.conf
# fin test php

#RUN		php-fpm8.1 -F
ENTRYPOINT	["nginx"]
CMD			["-g", "daemon off;"]

STOPSIGNAL	SIGQUIT

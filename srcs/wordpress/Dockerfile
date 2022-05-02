# wordpress Dockerfile
FROM	debian:buster

ARG		MAINTAINER

LABEL	maintainer $MAINTAINER

# php8 packages are not yet available by official Debian Mirrors, so it remains 2
# solutions : the first is to manually install php via downloading from the php
# website. The official docker php image does that. I do not know why, but
# when I try to install, the install take at least one hour, it is too much so
# let me talk about the second way : downloading packages via the deb.sury.org
# repository. It is the repository of the maintainer of the php packages (he
# explains this very well on his main website page. He is a debian dev.) 
# But we have to add manually this repository to our system
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
		php8.1-readline \
		php8.1-snmp \
		php-json \
		php8.1-intl \
		php8.1-zip \
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
		less \
		&& mkdir -p /var/run/php

# Copy configs files
COPY	/conf/php.ini /etc/php/8.1/fpm/php.ini
COPY	/conf/www.conf /etc/php/8.1/fpm/pool.d/www.conf

# Wordpress
WORKDIR	/var/www/alellouc.42.fr
RUN		curl -sSLo /var/www/alellouc.42.fr/latest-fr_FR.tar.gz \
		https://fr.wordpress.org/latest-fr_FR.tar.gz \
		&& tar -xvzf latest-fr_FR.tar.gz \
		&& rm -rf latest-fr_FR.tar.gz

# Il nous faut wp-cli pour terminer l'install de Wordpress en ligne de commande
RUN		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
		&& chmod +x wp-cli.phar \
		&& mv wp-cli.phar /usr/local/bin/wp
#wp core install --allow-root --url=https://alellouc.42.fr --title=inception
#		--admin_user=$MYSQL_USER --admin_email=alellouc@student.42nice.fr //
#		admin passwd = U!Bi9Kd!FInbUmGCI^
#RUN		wp core download
COPY	/tools/gen-wp-config.sh ./gen-wp-config.sh
RUN		./gen-wp-config.sh ./wordpress/wp-config.php \
		&& chmod 644 wordpress/wp-config.php
#RUN		wp core install --allow-root
# -> mais tant que la bdd n'est pas cree lance une erreur
RUN		chown www-data:www-data -R /var/www/alellouc.42.fr/wordpress
# Only for testing php working
COPY	/conf/index.php				/var/www/alellouc.42.fr/index.php

# Launching php deamon
CMD		["php-fpm8.1", "-F"]

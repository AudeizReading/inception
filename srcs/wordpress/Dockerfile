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
# explains this very well on his main website page. He is a debian dev. 
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
		php8.1-cgi
#COPY	/etc/php8.1/fpm/pool.d/www.conf /var/www/html/www.conf
	#	&& apt-get install -y curl make gcc autoconf dpkg-dev pkg-config\
	#	g++ gcc libc-dev re2c gnupg dirmngr\
	#	libargon2-dev \
	#	libcurl4-openssl-dev \
	#	libonig-dev \
	#	libreadline-dev \
	#	libsodium-dev \
	#	libsqlite3-dev \
	#	libssl-dev \
	#	libxml2-dev \
	#	zlib1g-dev \
	#	&& cd /usr/src \
	#	&& curl -o "./php-8.1.5.tar.gz" https://www.php.net/distributions/php-8.1.5.tar.gz \ 
	#	&& tar -xzvf php-8.1.5.tar.gz \
	#	&& cd ./php-8.1.5 \
	#	&& ./configure --enable-fpm --with-mysqli \
	#	&& make \
	#	&& make install
CMD		["/bin/sh", "-c", "/bin/sh"]
#CMD		["php-fpm", "-f"]

# nginx Dockerfile

# As allowed, taking the debian:buster image already existing
# I do not know how to build an OS like this without this option, maybe by
# looking at the Dockerfile of the debian image, but I only doubt that is the
# purpoose of the subject
FROM	debian:buster

ARG		MAINTAINER
ARG		CA_PATH
ARG		CA_KEY_PATH
ARG		CA_CRT_PATH
ARG		CA_NEWCRT_PATH
ARG		CA_CONFIG_PATH
ARG		CA_CONFIG
ARG		CA_SERIAL
ARG		CA_INDEX
ARG		CA_KEY
ARG		CA_CSR
ARG		CA_CRT
ARG		CA_C
ARG		CA_ST
ARG		CA_L
ARG		CA_O
ARG		CA_OU
ARG		CA_CN
ARG		CA_EMAIL
ARG		SSL_PATH
ARG		SSL_KEY
ARG		SSL_CSR
ARG		SSL_CRT
ARG		FQDN

LABEL	maintainer $MAINTAINER
VOLUME	/var/www/data

# Downloading nginx packages et set config for nginx user
# Forwarding stdout and stderr to nginx's corresponding logfile
RUN		addgroup --system --gid 101 nginx \
		&& adduser --system --disabled-login --ingroup nginx --no-create-home \
			--home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx \
		&& apt-get update -y && apt-get upgrade -y \
		&& apt-get install -y nginx-full ca-certificates openssl \
		&& ln -sf /dev/stdout /var/log/nginx/access.log \
		&& ln -sf /dev/stderr /var/log/nginx/error.log

# Setting an authority for signing certs, but seems it does not work with Google
# Chrome
# Works with Safari but need main host password as admin
# Works better with Firefox, we can access to the webpage after being warned
# Works in CLI with lynx browser
RUN		mkdir -p $CA_PATH $CA_KEY_PATH $CA_CRT_PATH $CA_NEWCRT_PATH $CA_CONFIG_PATH $SSL_PATH \
		&& cd $CA_PATH && touch $CA_INDEX && echo '01' > $CA_SERIAL
COPY	/conf/ca-ssl.cnf $CA_CONFIG
RUN		openssl genrsa -out $CA_KEY 4096 \
		&& openssl req -new -key $CA_KEY -out $CA_CSR -sha256 -batch \ 
		-subj "/C=$CA_C/ST=$CA_ST/L=$CA_L/O=$CA_O/OU=$CA_OU/emailAddress=$CA_EMAIL/CN=$CA_CN/" \
		&& openssl x509 -req -days 3650 -signkey $CA_KEY -in $CA_CSR -out $CA_CRT \ 
		&& rm -rf CA_CSR && chmod 400 $CA_KEY

# Getting an ssl certificate signed by our own CA (we do not have a real IP for
# registering our fqdn to a authentic CA
RUN		openssl genrsa -out $SSL_KEY 4096 \
		&& openssl req -nodes -new -key $SSL_KEY -batch -subj "/C=$CA_C/ST=$CA_ST/O=$CA_O/CN=$FQDN/" -out $SSL_CSR \
		&& openssl ca -config $CA_CONFIG -batch -in $SSL_CSR -out $SSL_CRT

# Copying config files needed for the well nginx running
# Intercepts 443 traffic
COPY	/conf/html.conf /etc/nginx/conf.d/html.conf
COPY	/conf/nginx.conf /etc/nginx/nginx.conf
COPY	/conf/index.html /var/www/html/index.html

EXPOSE	443

ENTRYPOINT	["nginx"]
CMD			["-g", "daemon off;"]

STOPSIGNAL	SIGQUIT

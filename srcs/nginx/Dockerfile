# nginx Dockerfile
FROM	debian:buster
ARG		SSL_KEY
ARG		SSL_CSR
ARG		SSL_CRT
ARG		SSL_DER
ARG		SSL_PATH
ARG		FQDN
LABEL	maintainer alellouc
VOLUME	/var/www/data
ENV		SSL_PATH="$SSL_PATH" SSL_KEY="$SSL_KEY" SSL_CSR="$SSL_CSR" SSL_CRT="$SSL_CRT" SSL_DER="$SSL_DER" FQDN="$FQDN"
RUN		set -x \
		&& addgroup --system --gid 101 nginx \
		&& adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx \
		&& apt-get update -y && apt-get upgrade -y \
		&& apt-get install -y nginx-full ca-certificates openssl curl lynx \
		&& ln -sf /dev/stdout /var/log/nginx/access.log \
		&& ln -sf /dev/stderr /var/log/nginx/error.log 
#COPY	/conf/openssl.cnf /usr/lib/ssl/openssl.cnf
RUN		mkdir -p $SSL_PATH  \
		&& openssl genrsa -out $SSL_KEY 4096 \
		&& openssl req -nodes -new -key $SSL_KEY -subj "/CN=$FQDN/" -out $SSL_CSR \
		&& openssl x509 -req -days 3650 -in $SSL_CSR -signkey $SSL_KEY -out $SSL_CRT\
		&& openssl x509 -in $SSL_CRT -out $SSL_DER -outform DER
COPY	/conf/html.conf /etc/nginx/conf.d/html.conf
COPY	/conf/nginx.conf /etc/nginx/nginx.conf
COPY	/conf/index.html /var/www/html/index.html
EXPOSE	443
ENTRYPOINT	["nginx"]
CMD			["-g", "daemon off;"]
STOPSIGNAL	SIGQUIT

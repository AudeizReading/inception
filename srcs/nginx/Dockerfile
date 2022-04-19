# nginx Dockerfile
FROM	debian:buster
LABEL	maintainer alellouc
VOLUME	/var/www/data
ENV		SSL_KEY=/var/ssl/alellouc.42.fr/inception.key
ENV		SSL_CSR=/var/ssl/alellouc.42.fr/inception.csr
ENV		SSL_CRT=/var/ssl/alellouc.42.fr/inception.crt
ENV		SSL_DER=/var/ssl/alellouc.42.fr/inception.der
ENV		FQDN=alellouc.42.fr
#VOLUME	/srv	
RUN		set -x \
		&& addgroup --system --gid 101 nginx \
		&& adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx \
		&& apt-get update -y && apt-get upgrade -y \
		&& apt-get install -y nginx-full ca-certificates openssl curl lynx \
		&& ln -sf /dev/stdout /var/log/nginx/access.log \
		&& ln -sf /dev/stderr /var/log/nginx/error.log 
RUN		mkdir -p /var/ssl/alellouc.42.fr  \
		&& openssl genrsa -out /var/ssl/alellouc.42.fr/inception.key 2048 \
		&& openssl req -nodes -new -key /var/ssl/alellouc.42.fr/inception.key \
		-subj "/CN=$FQDN/" -out /var/ssl/alellouc.42.fr/inception.csr \
		&& openssl x509 -req -days 3650 -in $SSL_CSR -signkey $SSL_KEY -out $SSL_CRT\
	#	-extfile <(printf "\nsubjectAltName='DNS:alellouc.42.fr'") \
		&& openssl x509 -in $SSL_CRT -out $SSL_DER -outform DER
COPY	/conf/html.conf /etc/nginx/conf.d/html.conf
COPY	/conf/nginx.conf /etc/nginx/nginx.conf
COPY	/conf/index.html /var/www/html/index.html
EXPOSE	443
ENTRYPOINT	["nginx"]
CMD			["-g", "daemon off;"]
STOPSIGNAL	SIGQUIT

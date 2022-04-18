# nginx Dockerfile
FROM	debian:buster
LABEL	maintainer alellouc
RUN		set -x \
		&& addgroup --system --gid 101 nginx \
		&& adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx \
		&& apt-get update -y && apt-get upgrade -y \
		&& apt-get install -y ca-certificates lsb-release \
		&& apt-get install -y nginx-full openssl certbot lynx \
		&& ln -sf /dev/stdout /var/log/nginx/access.log \
		&& ln -sf /dev/stderr /var/log/nginx/error.log \
		&& mkdir -p /srv/www /srv/conf/
COPY	/conf/html.conf /etc/nginx/conf.d/html.conf
COPY	/conf/nginx.conf /etc/nginx/nginx.conf
COPY	/conf/index.html /usr/share/nginx/html/index.html
EXPOSE	443
VOLUME	$HOME/data/front-end
ENTRYPOINT	["nginx"]
CMD			["-g", "daemon off;"]
STOPSIGNAL	SIGQUIT

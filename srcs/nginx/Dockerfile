# nginx Dockerfile
FROM	debian:buster
LABEL	maintainer alellouc
COPY	conf/nginx.conf /etc/nginx/nginx.conf
RUN		set -x \
		&& addgroup --system --gid 101 nginx \
		&& adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx \
		&& apt-get update && apt-get upgrade -y\
		&& apt-get install -y nginx-full lynx \
		&& ln -sf /dev/stdout /var/log/nginx/access.log \
		&& ln -sf /dev/stdin /var/log/nginx/error.log
EXPOSE	80 443
ENTRYPOINT	["nginx"]
CMD			["-g", "daemon off;"]
STOPSIGNAL	SIGQUIT

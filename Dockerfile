
FROM nginx:1.18-alpine as nginx
FROM node:14-alpine
LABEL maintainer="Goavega Open Source Team"
LABEL version 2.0

COPY --from=nginx /usr/sbin/nginx* /usr/sbin/
COPY --from=nginx /etc/nginx/ /etc/nginx/
COPY --from=nginx /var/log/nginx/ /var/log/nginx/
COPY --from=nginx /usr/lib/libpcre* /usr/lib/
COPY --from=nginx /var/cache/nginx/ /var/cache/nginx/
#########IMAGE RELATED ENVs###############
ENV SUPERVISOR_CONF_FILE /etc/supervisord.conf
##########################################
RUN set -x \
# create nginx user/group first, to be consistent throughout docker variants
    && addgroup -g 101 -S nginx \
    && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

STOPSIGNAL SIGTERM
####################Copy nginx conf########
RUN apk add --update --no-cache supervisor
RUN apk add --update --no-cache tzdata
COPY ./dockersupport/nginx-config.conf /etc/nginx/conf.d/default.conf
COPY ./www/ /var/www/
COPY ./dockersupport/start.sh /usr/local/bin/
COPY ./dockersupport/supervisord.conf $SUPERVISOR_CONF_FILE
RUN chmod u+x /usr/local/bin/start.sh
#USER nginx
###########################################
CMD ["start.sh"]
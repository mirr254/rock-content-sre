FROM wordpress:php7.1-apache

#update package being used
RUN apt-get update

COPY scripts ./
RUN bash plugins.sh

ADD https://downloads.wordpress.org/plugin/rock-convert.2.5.0.zip /opt/bitnami/wordpress/wp-content/plugins

ENTRYPOINT [ "/app-entrypoint.sh" ]
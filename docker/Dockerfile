FROM wordpress:5.5.3-php7.3-apache AS build

WORKDIR /usr/src/wp-cli/
#install wp-cli
RUN curl -Os https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar wp

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    unzip && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app/
COPY scripts/ /usr/src/app/
RUN sh install.sh && \
    rm -rf \
    install.sh \
    plugins.txt 

###

FROM wordpress:5.5.3-php7.3-apache

COPY --from=build /usr/src/wp-cli/wp /usr/local/bin/
COPY --from=build /usr/src/app/ /usr/src/wordpress/wp-content/

RUN cd /usr/src/wordpress/wp-content/ && \
    rm -rf \
    plugins/akismet/ \
    plugins/hello.php \
    themes/twentyseventeen/ \
    themes/twentynineteen/ \
    themes/twentytwenty/ 

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
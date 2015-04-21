FROM debian:wheezy

MAINTAINER Rik van der Kemp <rik@mief.nl>

ENV DEBIAN_FRONTEND noninteractive

# Need wget, update and install
RUN apt-get update && apt-get install wget -y

# Adding Dotdeb for PHP 5.4 and desired PHP version
RUN echo 'deb http://packages.dotdeb.org wheezy-php55 all' >> /etc/apt/sources.list  && echo 'deb-src http://packages.dotdeb.org wheezy-php55 all' >> /etc/apt/sources.list

# Dotdeb requires apt key, get it and add
RUN wget http://www.dotdeb.org/dotdeb.gpg && apt-key add dotdeb.gpg

# Update repositories once again to have access to dotdeb
RUN apt-get update

RUN apt-get install -yq \
        nginx-full  \
        php5  \
        php5-cli  \
        php5-curl \
        php5-gd \
        php5-intl \
        php5-mcrypt \
        php5-mysql \
        php5-xdebug \
        php5-fpm

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN echo "xdebug.max_nesting_level=300" >> /etc/php5/fpm/conf.d/20-xdebug.ini
RUN echo "xdebug.var_display_max_depth=8" >> /etc/php5/fpm/conf.d/20-xdebug.ini

COPY etc/nginx/nginx.conf /etc/nginx.conf

# Expose sites folder for mounting
VOLUME ["/sites"]

# Adding necessary files
ADD run.sh /run.sh
RUN chmod +x run.sh

EXPOSE 80

CMD ["/run.sh"]
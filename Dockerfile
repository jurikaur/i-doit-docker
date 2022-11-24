FROM ubuntu:22.04
ENV LANG en_US.utf8
RUN apt-get update && \
    apt-get install -yq tzdata software-properties-common \
#    && ln -fs /usr/share/zoneinfo/Europe/Tallinn /etc/localtime \
#    && dpkg-reconfigure -f noninteractive tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && add-apt-repository ppa:ondrej/php -y
ENV TZ="America/New_York"
RUN apt-get update && apt-get install -y \
    php8.0 \
    mariadb-client \
    apache2  \
    libapache2-mod-php \
    php8.0-bcmath \
    php8.0-ctype \
    php8.0-curl \
    php8.0-fileinfo \
    php8.0-gd \
    php8.0-imagick \
    php-json \
    php8.0-ldap \
    php8.0-mbstring \
    php8.0-memcached \
    php8.0-mysqli \
    php8.0-mysqlnd \
    php8.0-pgsql \
    php8.0-soap \
    php8.0-xml \
    php8.0-zip \
    memcached \
    zip \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/www/html/i-doit
ADD idoit-open-1.19.zip /var/www/html/i-doit/idoit-open-1.19.zip
VOLUME /var/www/html/i-doit/upload /var/www/html/i-doit/src
ADD ./scripts /scripts
RUN chmod +x /scripts/init.sh
ENTRYPOINT /bin/bash /scripts/init.sh
EXPOSE 80
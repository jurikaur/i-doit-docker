#!/bin/bash

# define path to custom docker environment
DOCKER_ENVVARS=/etc/apache2/docker_envvars

# write variables to DOCKER_ENVVARS
cat << EOF > "$DOCKER_ENVVARS"
export APACHE_RUN_USER=www-data
export APACHE_RUN_GROUP=www-data
export APACHE_LOG_DIR=/var/log/apache2
export APACHE_LOCK_DIR=/var/lock/apache2
export APACHE_PID_FILE=/var/run/apache2.pid
export APACHE_RUN_DIR=/var/run/apache2
EOF

# source environment variables to get APACHE_PID_FILE
. "$DOCKER_ENVVARS"

# only delete pidfile if APACHE_PID_FILE is defined
if [ -n "$APACHE_PID_FILE" ]; then
   rm -f "$APACHE_PID_FILE"
fi

# line copied from /etc/init.d/apache2
ENV="env -i LANG=C PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# install i-doit
cd /var/www/html/i-doit \
&& unzip -q -n /var/www/html/i-doit/idoit-open-1.19.zip \
&& rm /var/www/html/i-doit/idoit-open-1.19.zip \
&& chown www-data:www-data -R /var/www/html/i-doit \
&& find /var/www/html/i-doit/ -type d -name \* -exec chmod 775 {} \; \
&& find /var/www/html/i-doit/ -type f -exec chmod 664 {} \; \
&& chmod 774 /var/www/html/i-doit/controller /var/www/html/i-doit/*.sh /var/www/html/i-doit/setup/*.sh \
&& a2enmod rewrite \
&& sed -i 's/;max_input_vars = 1000/max_input_vars = 11000/g' /etc/php/8.0/apache2/php.ini \
&& sed -i 's/post_max_size = 8M/post_max_size = 150M/g' /etc/php/8.0/apache2/php.ini

# use apache2ctl instead of /usr/sbin/apache2
$ENV APACHE_ENVVARS="$DOCKER_ENVVARS" apache2ctl -DFOREGROUND
ARG PHP_VERSION
FROM php:$PHP_VERSION

# To run files with the same group as your primary user

COPY .docker/wait-for-it.sh /tmp/
COPY .docker/docker_run_git.sh /tmp/

RUN mkdir -p /var/www/.npm
RUN chown -R www-data:www-data /var/www/.npm
RUN mkdir -p /var/www/.composer
RUN chown -R www-data:www-data /var/www/.composer

# install packages
RUN apt-get update -y && \
  apt-get install -y --no-install-recommends \
  less vim wget unzip rsync git default-mysql-client libzip-dev ssl-cert \
  libcurl4-openssl-dev libfreetype6 libjpeg62-turbo libpng-dev libjpeg-dev libxml2-dev libxpm4 && \
  apt-get clean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/* && \
  echo "export TERM=xterm" >> /root/.bashrc
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt install -y nodejs

# install php extensions
RUN docker-php-ext-configure gd --with-jpeg && \
  docker-php-ext-install -j$(nproc) zip bcmath soap pdo_mysql gd

# composer stuff
RUN php -r 'readfile("https://getcomposer.org/installer");' > composer-setup.php \
  && php composer-setup.php --version=2.2.14 --install-dir=/usr/local/bin --filename=composer \
  && rm -f composer-setup.php \
  && chown www-data:www-data /var/www


# Install mailutils to make sendmail work
RUN apt install -y \
    apt-utils \
    mailutils

CMD ["/tmp/docker_run_git.sh"]

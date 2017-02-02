# Install php 7
yum install -y \
  mod_php71w \
  php71w-bcmath \
  php71w-cli \
  php71w-common \
  php71w-dba \
  php71w-devel \
  php71w-embedded \
  php71w-enchant \
  php71w-fpm \
  php71w-gd \
  php71w-imap \
  php71w-interbase \
  php71w-intl \
  php71w-ldap \
  php71w-mbstring \
  php71w-mcrypt \
  php71w-mysqlnd \
  php71w-odbc \
  php71w-opcache \
  php71w-pdo \
  php71w-pdo_dblib \
  php71w-pear \
  php71w-pecl-apcu \
  php71w-pecl-mongodb \
  php71w-pecl-redis \
  php71w-pgsql \
  php71w-phpdbg \
  php71w-process \
  php71w-pspell \
  php71w-recode \
  php71w-snmp \
  php71w-soap \
  php71w-tidy \
  php71w-xml

# Disable httpd
systemctl disable httpd
systemctl disable php-fpm

# Install composer
echo "====================================="
echo "        install composer"
echo "====================================="
local home_bin="${HOME}/bin"
test -d $home_bin || mkdir -p $home_bin
cd $home_bin

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '55d6ead61b29c7bdee5cccfb50076874187bd9f21f65d8991d46ec5cc90518f447387fb9f76ebae1fbbacf329e583e30') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

mv composer*.phar composer


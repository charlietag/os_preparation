# =====================
# Enable databag
# =====================
# RENDER_CP

echo "==============================="
echo "        Render repo"
echo "==============================="
rpm -Uvh $epel_yum_repo
rpm -Uvh $php_yum_repo

echo "==============================="
echo "     Install php 7.1"
echo "==============================="
# Install php 7.1
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


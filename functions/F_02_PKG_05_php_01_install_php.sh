# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

echo "==============================="
echo "        Render repo"
echo "==============================="
#EPEL installed in basic_pkg
#rpm -Uvh $epel_dnf_repo

#rpm -Uvh $php_dnf_repo

# Using remi instead
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm

echo "==============================="
echo "     Install php:${php_remi_stream}"
echo "==============================="
if ! $(dnf module list php:${php_remi_stream} --enabled >/dev/null 2>/dev/null) ; then
  dnf module reset php -y
  dnf module enable php:${php_remi_stream}/devel -y
fi
dnf module install php:${php_remi_stream}/devel -y

# --- PHP Image ---
# php72w-pecl-imagick ---> requires ImageMagick 6.7.8 (installed via centos repo 'base','update', latest version 6.9+ is not supported)
# use php-gd instead for image manipulation
#dnf install php72w-pecl-imagick  

# mod_php72w , is for /var/lib/php/session folder (php-fpm use), kernel module - mod_php (apache)
# Install php 7.2
dnf install -y \
  php \
  php-bcmath \
  php-cli \
  php-common \
  php-dba \
  php-devel \
  php-embedded \
  php-enchant \
  php-fpm \
  php-gd \
  php-imap \
  php-intl \
  php-ldap \
  php-mbstring \
  php-mysqlnd \
  php-odbc \
  php-opcache \
  php-pdo \
  php-pdo_dblib \
  php-pear \
  php-pecl-apcu \
  php-pecl-mongodb \
  php-pecl-redis \
  php-pgsql \
  php-process \
  php-pspell \
  php-snmp \
  php-soap \
  php-sodium \
  php-tidy \
  php-xml \
  php-xmlrpc

# Disable httpd
echo "systemctl disable httpd......"
systemctl disable httpd
echo ""

echo "systemctl disable php-fpm......"
systemctl disable php-fpm
echo ""

# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

echo "==============================="
echo "        Render repo"
echo "==============================="
#EPEL installed in basic_pkg
#rpm -Uvh $epel_dnf_repo

rpm -Uvh $php_dnf_repo

echo "==============================="
echo "     Install php 7.2"
echo "==============================="

# --- PHP Image ---
# php72w-pecl-imagick ---> requires ImageMagick 6.7.8 (installed via centos repo 'base','update', latest version 6.9+ is not supported)
# use php-gd instead for image manipulation
#dnf install php72w-pecl-imagick  

# mod_php72w , is for /var/lib/php/session folder (php-fpm use), kernel module - mod_php (apache)
# Install php 7.2
dnf install -y \
  mod_php72w \
  php72w-bcmath \
  php72w-cli \
  php72w-common \
  php72w-dba \
  php72w-devel \
  php72w-embedded \
  php72w-enchant \
  php72w-fpm \
  php72w-gd \
  php72w-imap \
  php72w-interbase \
  php72w-intl \
  php72w-ldap \
  php72w-mbstring \
  php72w-mysqlnd \
  php72w-odbc \
  php72w-opcache \
  php72w-pdo \
  php72w-pdo_dblib \
  php72w-pear \
  php72w-pecl-apcu \
  php72w-pecl-mongodb \
  php72w-pecl-redis \
  php72w-pgsql \
  php72w-phpdbg \
  php72w-process \
  php72w-pspell \
  php72w-recode \
  php72w-snmp \
  php72w-soap \
  php72w-sodium \
  php72w-tidy \
  php72w-xml \
  php72w-xmlrpc

# Disable httpd
echo "systemctl disable httpd......"
systemctl disable httpd
echo ""

echo "systemctl disable php-fpm......"
systemctl disable php-fpm
echo ""

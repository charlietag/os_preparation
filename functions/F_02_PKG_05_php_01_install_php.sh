# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# ###########################################################
# Using 3rd repo (Deprecated)
# ###########################################################
# echo "==============================="
# echo "        Render repo"
# echo "==============================="
#EPEL installed in basic_pkg
#rpm -Uvh $epel_dnf_repo

#rpm -Uvh $php_dnf_repo

# # Using remi instead
# if ! $(rpm --quiet -q remi-release) ; then
#   dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm
#   #L_UPDATE_REPO 5000
# fi

# echo "==============================="
# echo "     Install php:${php_remi_stream}"
# echo "==============================="
# if ! $(dnf module list php:${php_remi_stream} --enabled >/dev/null 2>/dev/null) ; then
#   dnf module reset php -y
#   #dnf module enable php:${php_remi_stream}/devel -y
#   #   -> Ignoring unnecessary profile: devel
#   dnf module enable php:${php_remi_stream} -y
# fi
# dnf module install php:${php_remi_stream}/devel -y

# --- PHP (Remi version) ---
# /var/lib/php/session folder (php-fpm use)- (apache - mod_php)
# Install php
# dnf install -y \
#   php \
#   php-bcmath \
#   php-cli \
#   php-common \
#   php-dba \
#   php-devel \
#   php-embedded \
#   php-enchant \
#   php-fpm \
#   php-gd \
#   php-imap \
#   php-intl \
#   php-ldap \
#   php-mbstring \
#   php-mysqlnd \
#   php-odbc \
#   php-opcache \
#   php-pdo \
#   php-pdo_dblib \
#   php-pear \
#   php-pecl-apcu \
#   php-pecl-mongodb \
#   php-pecl-redis \
#   php-pgsql \
#   php-process \
#   php-pspell \
#   php-snmp \
#   php-soap \
#   php-sodium \
#   php-tidy \
#   php-xml \
#   php-xmlrpc

# ###########################################################
# Install php
# ###########################################################
# --- PHP (AppStream version) ---
# /var/lib/php/session folder (php-fpm use)- (apache - mod_php)
# Install php

# The following packages contain all pkgs in module install php:{version}/devel
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
  php-intl \
  php-ldap \
  php-mbstring \
  php-mysqlnd \
  php-odbc \
  php-opcache \
  php-pdo \
  php-pear \
  php-pecl-apcu \
  php-pgsql \
  php-process \
  php-snmp \
  php-soap \
  php-xml \
  libzip \
  php-json \
  php-pecl-zip

# --------------------------------------------------------------------------------------
# Packages not included above, use pecl install
#   pecl - install *.so files which needs to be included by extension = xxxx.so
#   pear - should be replaced by composer.phar
# --------------------------------------------------------------------------------------

# Packages not included above, use pecl install
  # php-imap \
  # php-pdo_dblib \
  # php-pecl-mongodb \
  # php-pecl-redis \
  # php-pspell \
  # php-sodium \
  # php-tidy \
  # php-xmlrpc \

# --- For connecting to SQL server ---
# dnf install -y unixODBC-devel
# pecl install pdo_sqlsrv sqlsrv

# --- successfully installed messages ---
# Build process completed successfully
# Installing '/usr/lib64/php/modules/sqlsrv.so'
# install ok: channel://pecl.php.net/sqlsrv-5.8.1

# configuration option "php_ini" is not set to php.ini location
# You should add "extension=sqlsrv.so" to php.ini
# You should add "extension=pdo_sqlsrv.so" to php.ini

# --------------------------------------------------------------------------------------

# Disable httpd
echo "systemctl disable httpd......"
systemctl disable httpd
echo ""

echo "systemctl disable php-fpm......"
systemctl disable php-fpm
echo ""

# --------------------------------------------------------------------------
# Make sure php-fpm is not started by nginx
# --------------------------------------------------------------------------
#sed -e 's/^#*/#/' -i /usr/lib/systemd/system/nginx.service.d/php-fpm.conf
task_copy_using_cat
chmod 755 /opt/php_fpm_scripts/*.sh
# *********************************
# Adding scripts into crontab
# *********************************
local cron_php_fpm_script="/opt/php_fpm_scripts/php-fpm_decouple_nginx.sh"
echo "Adding php-fpm check script into crontab..."
sed -re "/${cron_php_fpm_script//\//\\/}/d" -i /etc/crontab
echo "1 6 * * * root ${cron_php_fpm_script}" >> /etc/crontab
$cron_php_fpm_script

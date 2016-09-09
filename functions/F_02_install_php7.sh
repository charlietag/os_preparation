# Install php 7
yum install -y php70w php70w-opcache php70w-fpm php70w-opcache php70w-mbstring php70w-mcrypt php70w-mysql php70w-pdo php70w-pdo_dblib php70w-gd php70w-common

# For composer
yum install -y php70w-xml

# Disable httpd
systemctl disable httpd

# Install composer
echo "====================================="
echo "        install composer"
echo "====================================="
local home_bin="~/bin"
test -d $home_bin || mkdir -p $home_bin
cd $home_bin
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

mv composer*.phar composer


cd /home
echo "========================================="
echo "      composer create-project ---> mylaravel"
echo "========================================="
composer create-project --prefer-dist laravel/laravel mylaravel

cd /home/mylaravel
chown -R apache.apache storage
chown -R apache.apache bootstrap/cache

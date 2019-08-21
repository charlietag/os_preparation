# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# Install composer
# Ref. https://getcomposer.org/doc/faqs/how-to-install-composer-programmatically.md
echo "====================================="
echo "        install composer"
echo "====================================="
local home_bin="${current_user_home}/bin"
test -d $home_bin || mkdir -p $home_bin
cd $home_bin

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
local expected_signature=$(wget -q -O - https://composer.github.io/installer.sig)
local actual_signature=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

if [ "$expected_signature" != "$actual_signature" ]
then
    echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi
echo "Installer verified"
php composer-setup.php
php -r "unlink('composer-setup.php');"

test -f composer && rm -f composer
mv composer*.phar composer

#-----------------------------------------------------------------------------------------
#Make sure user_home priv is correct
#-----------------------------------------------------------------------------------------
chown -R ${current_user}.${current_user} ${current_user_home}

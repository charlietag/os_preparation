# =====================
# Enable databag
# =====================
# RENDER_CP

#---------------
#Setup php-fpm pool "www"
#Value in pool "www" would override default valie in /etc/php.ini
#---------------
echo "-----------"
echo "setup php-fpm pool \"www\""
echo "-----------"
local php_confs=($(find ${CONFIG_FOLDER} -type f))
local php_target=""
local php_target_folder=""
for php_conf in ${php_confs[@]}
do
  php_target="${php_conf/${CONFIG_FOLDER}/}"
  php_target_folder="$(dirname $php_target)"

  test -d $php_target_folder || mkdir -p $php_target_folder

  # use RENDER_CP to fetch var from datadog
  RENDER_CP $php_conf $php_target
done


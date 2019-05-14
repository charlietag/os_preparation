# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

#---------------
#Setup php-fpm pool "www"
#Value in pool "www" would override default valie in /etc/php.ini
#---------------
task_copy_using_render


#---------------
# make sure default session is writeable by php user
#---------------
chown -R ${current_user}.${current_user} /var/lib/php/*

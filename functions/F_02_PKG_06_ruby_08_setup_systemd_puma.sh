# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

#--------------------------
#  Setup configs
#--------------------------
task_copy_using_cat

sed -i "s/RAILS_SERVICE_USERNAME/${current_user}/g" /usr/local/bin/puma-mgr
chmod 755 /usr/local/bin/puma-mgr

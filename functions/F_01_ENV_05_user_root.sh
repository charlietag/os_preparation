# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable
helper_env_user_base

#task_copy_using_cat_user_home
# use sed instead, because need replace var defined in databag for custom aliases command
task_copy_using_sed_user_home
chmod 755 /root/bin/*

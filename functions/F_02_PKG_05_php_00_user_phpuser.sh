# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable
task_add_no_ssh_user

helper_env_user_base

task_copy_using_cat_user_home

su -l $current_user -c "test -d ${web_sites} || mkdir -p ${web_sites}"

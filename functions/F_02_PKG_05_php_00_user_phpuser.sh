# =====================
# Enable databag
# =====================
# RENDER_CP
task_add_no_ssh_user

helper_env_user_base

task_copy_using_cat_user_home

su -l $current_user -c "test -d ${laravel_sites} || mkdir -p ${laravel_sites}"

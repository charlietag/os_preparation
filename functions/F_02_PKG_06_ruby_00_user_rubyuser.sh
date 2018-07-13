# =====================
# Enable databag
# =====================
# RENDER_CP
helper_add_no_ssh_user
helper_env_user_base
helper_copy_using_cat_user_home

su -l $current_user -c "test -d ${rails_sites} || mkdir -p ${rails_sites}"

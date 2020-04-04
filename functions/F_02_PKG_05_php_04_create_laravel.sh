# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

echo "========================================="
echo "(Laravel:${laravel_version}) composer create-project ---> mylaravel"
echo "========================================="

su -l $current_user -c "test -d ${web_sites} || mkdir -p ${web_sites}"

su -l $current_user -c "cd $web_sites && composer create-project --prefer-dist laravel/laravel mylaravel \"${laravel_version}.*\""

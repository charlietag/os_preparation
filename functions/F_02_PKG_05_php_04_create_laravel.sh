# =====================
# Enable databag
# =====================
# RENDER_CP

echo "========================================="
echo "(Laravel:${laravel_version}) composer create-project ---> mylaravel"
echo "========================================="

su -l $current_user -c "test -d ${laravel_sites} || mkdir -p ${laravel_sites}"

su -l $current_user -c "cd $laravel_sites && composer create-project --prefer-dist laravel/laravel mylaravel \"${laravel_version}\""

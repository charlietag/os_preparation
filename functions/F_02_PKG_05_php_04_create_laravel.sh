# =====================
# Enable databag
# =====================
# RENDER_CP

echo "========================================="
echo "(Laravel:${laravel_version}) composer create-project ---> mylaravel"
echo "========================================="

test -d $laravel_sites || mkdir -p $laravel_sites

cd $laravel_sites

su -l $current_user -c "composer create-project --prefer-dist laravel/laravel mylaravel \"${laravel_version}\""

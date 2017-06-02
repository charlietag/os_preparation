# =====================
# Enable databag
# =====================
# RENDER_CP

echo "========================================="
echo "(Laravel:${laravel_version}) composer create-project ---> mylaravel"
echo "========================================="
cd /home
composer create-project --prefer-dist laravel/laravel mylaravel "${laravel_version}"

cd /home/mylaravel
chown -R apache.apache storage
chown -R apache.apache bootstrap/cache


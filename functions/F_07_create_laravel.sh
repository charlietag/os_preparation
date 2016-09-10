echo "========================================="
echo "      composer create-project ---> mylaravel"
echo "========================================="
cd /home
composer create-project --prefer-dist laravel/laravel mylaravel

cd /home/mylaravel
chown -R apache.apache storage
chown -R apache.apache bootstrap/cache


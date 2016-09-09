echo "========================================="
echo "      rails new myrails -d mysql"
echo "========================================="
cd /home
rails new myrails -d mysql #Create rails project, to verify
cd /home/myrails
chown -R optpass.optpass log tmp

systemctl start mariadb.service
bundle exec rails db:create:all
systemctl stop mariadb.service

echo "========================================="
echo "      rails new myrails -d mysql"
echo "========================================="
cd /home
rails new myrails -d mysql #Create rails project, to verify
cd /home/myrails
chown -R optpass.optpass log tmp

systemctl start mariadb

# Create PROD(require database.yml info. so PROD will failed due to wrong username/password for mysql db server), DEV, TEST env database in mysql
# bundle exec rails db:create:all

bundle exec rails db:create
systemctl stop mariadb

# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

# --- Remove spring to avoid err caused by spring cache ---
# * https://github.com/rails/spring#removal
#   * `bin/spring binstub --remove --all`
#   *  Remove spring from your Gemfile
#     *  `bundle install`
# --------------------------------------------------------

echo "========================================="
echo "(Rails:${rails_version}) rails new myrails -d mysql --skip-spring"
echo "========================================="

su -l $current_user -c "test -d ${web_sites} || mkdir -p ${web_sites}"

su -l $current_user -c "cd ${web_sites} && rails new myrails -d mysql --skip-spring" #Create rails project, to verify

su -l $current_user -c "cd ${web_sites}/myrails/config && ls *.yml | xargs -i cp -a {} {}.sample"

systemctl start mariadb
echo -n "starting mariadb"
sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; echo ""

# Create PROD(require database.yml info. so PROD will failed due to wrong username/password for mysql db server), DEV, TEST env database in mysql
# bundle exec rails db:create:all

su -l $current_user -c "cd ${web_sites}/myrails && bundle exec rails db:create"


systemctl stop mariadb
echo -n "stopping mariadb"
sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; echo ""


# Add extra config into .gitignore file
if [[ ! -f ${web_sites}/myrails/.gitignore ]]; then
  echo "FAILED: rails new myrails !"
  exit
fi

echo "========================================="
echo "      Add default ignore into myrails"
echo "========================================="
cat ${CONFIG_FOLDER}/user_home/rails_site/myrails/.gitignore >> ${web_sites}/myrails/.gitignore

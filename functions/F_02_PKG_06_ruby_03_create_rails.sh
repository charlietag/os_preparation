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

# --------------------DB-------------------------------
systemctl start redis
systemctl start mariadb
echo -n "starting mariadb and redis"
sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; echo ""
# --------------------DB-------------------------------

echo "========================================="
# Spring is not included started from rails 7
# echo "(Rails:${rails_version}) rails new myrails -d mysql --skip-spring"
echo "(Rails:${rails_version}) rails new myrails -d mysql"
echo "========================================="

su -l $current_user -c "test -d ${web_sites} || mkdir -p ${web_sites}"

# su -l $current_user -c "cd ${web_sites} && rails new myrails -d mysql --skip-spring" #Create rails project, to verify
su -l $current_user -c "cd ${web_sites} && rails new myrails -d mysql" #Create rails project, to verify

su -l $current_user -c "cd ${web_sites}/myrails/config && ls *.yml | xargs -I{} cp -a {} {}.sample"


# Create PROD(require database.yml info. so PROD will failed due to wrong username/password for mysql db server), DEV, TEST env database in mysql
# bundle exec rails db:create:all

su -l $current_user -c "cd ${web_sites}/myrails && bundle exec rails db:create"




# Add extra config into .gitignore file
if [[ ! -f ${web_sites}/myrails/.gitignore ]]; then
  echo "FAILED: rails new myrails !"
  exit
fi

echo "========================================="
echo "      Add default ignore into myrails"
echo "========================================="
cat ${CONFIG_FOLDER}/user_home/rails_site/myrails/.gitignore >> ${web_sites}/myrails/.gitignore
echo ""

echo "========================================="
echo "      Add gem \"sd_notify\" into myrails"
echo "========================================="
sed -i '/sd_notify/d' ${web_sites}/myrails/Gemfile

echo "" >> ${web_sites}/myrails/Gemfile
echo "# sd_notify - puma5 integrated with Systemd(type=notify)" >> ${web_sites}/myrails/Gemfile
echo "gem 'sd_notify', group: 'production'" >> ${web_sites}/myrails/Gemfile

su -l $current_user -c "cd ${web_sites}/myrails && bundle install"

# --------------------DB-------------------------------
systemctl stop redis
systemctl stop mariadb
echo -n "stopping mariadb and redis"
sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; echo ""
# --------------------DB-------------------------------

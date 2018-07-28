# =====================
# Enable databag
# =====================
# RENDER_CP

echo "========================================="
echo "      Install ruby ${redmine_ruby_version}"
echo "========================================="
su -l $current_user -c "rvm install ${redmine_ruby_version}"


#==================================
# Setup redmine env
#==================================
local redmine_web_root="${web_sites}/redmine"
if [[ -d $redmine_unzipped_folder ]]; then
  echo "WARN: folder exists \"${redmine_web_root}\""
  exit
fi

#==================================
# Start to download redmine & plugins
#==================================
local redmine_web_plugin_path="${redmine_web_root}/plugins"
echo "========================================="
echo "Downloading redmine ..."
echo "========================================="
cd ${TMP}

wget $redmine_url
unzip -q $redmine_downloaded_zip && rm -f $redmine_downloaded_zip
mv $redmine_unzipped_folder ${redmine_web_root}

for redmine_plugin in ${redmine_plugins[@]}; do
  echo "Downloading redmine_plugin -> $redmine_plugin ..."
  wget $redmine_plugin
done

ls *.zip 2>/dev/null | xargs -i unzip -q {}
rm -f *.zip
mv ${TMP}/* $redmine_web_plugin_path/

# Setup redmine ruby version and gemset
echo "${redmine_ruby_version}" > $redmine_web_root/.ruby-version
echo "redmine_gemset" > $redmine_web_root/.ruby-gemset

task_copy_using_cat_user_home_web_sites
RENDER_CP $CONFIG_FOLDER/user_home/web_sites/redmine/config/database.yml $redmine_web_root/config/database.yml
chown -R ${current_user}.${current_user} ${redmine_web_root}

# ====== Create database for redmine =======
systemctl start mariadb
echo -n "starting mariadb"
sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; echo ""

if [[ -z "${redmine_db_pass}" ]]; then
  mysql -u root -e "CREATE DATABASE redmine CHARACTER SET utf8;"
else
  mysql -u root -p${redmine_db_pass} -e "CREATE DATABASE redmine CHARACTER SET utf8;"
fi

# ====== Start to install redmine gem =======
su -l $current_user -c "cd ${redmine_web_root} && bundle install --without development test"
su -l $current_user -c "cd ${redmine_web_root} && bundle exec rake generate_secret_token RAILS_ENV=production"
su -l $current_user -c "cd ${redmine_web_root} && bundle exec rake db:migrate RAILS_ENV=production"
su -l $current_user -c "cd ${redmine_web_root} && bundle exec rake redmine:plugins RAILS_ENV=production"

# ====== Stop database after finishing installation =======
systemctl stop mariadb
echo -n "stopping mariadb"
sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; echo ""

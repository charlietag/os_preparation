# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

echo "========================================="
echo "      Install ruby ${redmine_ruby_version}"
echo "========================================="
su -l $current_user -c "rvm install ${redmine_ruby_version}"
#su -l $current_user -c "rvm use ${redmine_ruby_version} && (gem update --system ; gem update ; gem cleanup)"  # DO NOT cleanup gems, in case cleanup legacy gems which are still in use, for the same ruby version
su -l $current_user -c "rvm use ${redmine_ruby_version} && (gem update --system ; gem update)"

echo "========================================="
echo "      gem install bundler"
echo "========================================="
su -l $current_user -c "rvm use ${redmine_ruby_version} && gem install bundler"
echo ""


#==================================
# Setup redmine env
#==================================
local redmine_web_root="${web_sites}/redmine"
if [[ -d $redmine_web_root ]]; then
  echo "WARN: folder exists \"${redmine_web_root}\""
  exit
fi

#==================================
# Start to download redmine & plugins & themes
#==================================
echo "========================================="
echo "Downloading redmine ..."
echo "========================================="
cd ${TMP}

# ----- redmine core -----
wget $redmine_url
ls *.zip 2>/dev/null | xargs -i unzip -q {}
SAFE_DELETE "*.zip"
echo "Downloaded ZIP file unzipped already..."
mv ${TMP}/redmine-* ${redmine_web_root}
[[ -d ${redmine_web_root} ]] && echo -e "~~~ ${redmine_web_root} installed... ~~~\n\n\n"
# ----- redmine core -----



# ----- redmine plugins -----
local redmine_web_plugin_path_tmp="${TMP}/redmine_plugins"
test -d $redmine_web_plugin_path_tmp || mkdir -p $redmine_web_plugin_path_tmp
cd $redmine_web_plugin_path_tmp

local redmine_web_plugin_path="${redmine_web_root}/plugins"

for redmine_plugin in ${redmine_plugins[@]}; do
  echo "Downloading redmine_plugin -> $redmine_plugin ..."
  wget $redmine_plugin

  # ~~~ unzip & install plugins ~~~
  echo "Downloaded ZIP file unzipped already..."
  ls *.zip 2>/dev/null | xargs -i unzip -q {}
  SAFE_DELETE "*.zip"
  if [ -n "${redmine_plugins}" ]; then
    local redmine_plugins_with_ver_names="$(ls ${redmine_web_plugin_path_tmp})"
    for redmine_plugins_with_ver_name in ${redmine_plugins_with_ver_names[@]}; do
      local redmine_plugins_name="$(echo "${redmine_plugins_with_ver_name}" | cut -d'-' -f1)"
      [[ -d ${redmine_web_plugin_path}/${redmine_plugins_name} ]] && SAFE_DELETE "${redmine_web_plugin_path}/${redmine_plugins_name}"
      mv ${redmine_web_plugin_path_tmp}/${redmine_plugins_with_ver_name} ${redmine_web_plugin_path}/${redmine_plugins_name}
      [[ -d ${redmine_web_plugin_path}/${redmine_plugins_name} ]] && echo -e "~~~ ${redmine_web_plugin_path}/${redmine_plugins_name} installed... ~~~\n\n\n"
    done
  fi
  # ~~~ unzip & install plugins ~~~
done
cd $TMP
SAFE_DELETE "${redmine_web_plugin_path_tmp}"
# ----- redmine plugins -----



# ----- redmine themes -----
local redmine_web_theme_path_tmp="${TMP}/redmine_themes"
test -d $redmine_web_theme_path_tmp || mkdir -p $redmine_web_theme_path_tmp
cd $redmine_web_theme_path_tmp

local redmine_web_theme_path="${redmine_web_root}/public/themes"

for redmine_theme in ${redmine_themes[@]}; do
  echo "Downloading redmine_theme -> $redmine_theme ..."
  wget $redmine_theme

  # ~~~ unzip & install themes ~~~
  echo "Downloaded ZIP file unzipped already..."
  ls *.zip 2>/dev/null | xargs -i unzip -q {}
  SAFE_DELETE "*.zip"
  if [ -n "${redmine_themes}" ]; then
    local redmine_themes_with_ver_names="$(ls ${redmine_web_theme_path_tmp})"
    for redmine_themes_with_ver_name in ${redmine_themes_with_ver_names[@]}; do
      local redmine_themes_name="$(echo "${redmine_themes_with_ver_name}" | cut -d'-' -f1)"
      [[ -d ${redmine_web_theme_path}/${redmine_themes_name} ]] && SAFE_DELETE "${redmine_web_theme_path}/${redmine_themes_name}"
      mv ${redmine_web_theme_path_tmp}/${redmine_themes_with_ver_name} ${redmine_web_theme_path}/${redmine_themes_name}
      [[ -d ${redmine_web_theme_path}/${redmine_themes_name} ]] && echo -e "~~~ ${redmine_web_theme_path}/${redmine_themes_name} installed... ~~~\n\n\n"
    done
  fi
  # ~~~ unzip & install themes ~~~
done
cd $TMP
SAFE_DELETE "${redmine_web_theme_path_tmp}"
# ----- redmine themes -----


#==================================
# Setup config , ruby version , gemset name
#==================================
# Setup redmine ruby version and gemset
echo "${redmine_ruby_version}" > $redmine_web_root/.ruby-version
echo "${redmine_gemset}" > $redmine_web_root/.ruby-gemset

task_copy_using_cat_user_home_web_sites

cat $CONFIG_FOLDER/user_home/web_sites/redmine/config/configuration.yml.sample > $redmine_web_root/config/configuration.yml
RENDER_CP $CONFIG_FOLDER/user_home/web_sites/redmine/config/database.yml.sample $redmine_web_root/config/database.yml
sed -e '/puma/ s/^#*/#/' -i $redmine_web_root/Gemfile

chown -R ${current_user}.${current_user} ${redmine_web_root}

if [[ ! -f "${redmine_web_root}/.gitignore" ]]; then
  echo "FAILED: redmine installation failed !"
  exit
fi

#==================================
# Database setup
#==================================
# ====== Create database for redmine =======
echo -n "starting mariadb"
sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; echo ""
systemctl start mariadb

# Avoid difference command creating db between rails 4 , and rails 5, create db via mysql command
# And redmine doesn't seemt to support rails db:create
if [[ -z "${redmine_db_pass}" ]]; then
  mysql -u root -e "CREATE DATABASE ${redmine_db_name} CHARACTER SET utf8;"
else
  mysql -u root -p${redmine_db_pass} -e "CREATE DATABASE ${redmine_db_name} CHARACTER SET utf8;"
fi

# ====== Start to install redmine gem =======
echo "========================================="
echo "      gem install bundler -v ${redmine_bundler_version}  # Bundler 1.x for Redmine3.x (Rails 4)"
echo "========================================="
su -l $current_user -c "cd ${redmine_web_root} && (gem update --system ;  gem install bundler -v ${redmine_bundler_version})"
echo ""

su -l $current_user -c "cd ${redmine_web_root} && bundle _${redmine_bundler_version}_ install --without development test"
su -l $current_user -c "cd ${redmine_web_root} && bundle _${redmine_bundler_version}_ exec rake generate_secret_token"
# su -l $current_user -c "cd ${redmine_web_root} && bundle _${redmine_bundler_version}_ exec rake db:create RAILS_ENV=production"  #---> rails 4 , or below
#su -l $current_user -c "cd ${redmine_web_root} && bundle _${redmine_bundler_version}_ exec rails db:create RAILS_ENV=production"   #---> rails 5 , or above
su -l $current_user -c "cd ${redmine_web_root} && bundle _${redmine_bundler_version}_ exec rake db:migrate RAILS_ENV=production"
if [[ -n "${redmine_default_lang}" ]]; then
  su -l $current_user -c "cd ${redmine_web_root} && bundle _${redmine_bundler_version}_ exec rake redmine:load_default_data RAILS_ENV=production REDMINE_LANG=${redmine_default_lang}"
fi
su -l $current_user -c "cd ${redmine_web_root} && bundle _${redmine_bundler_version}_ exec rake redmine:plugins RAILS_ENV=production"

# ====== Stop database after finishing installation =======
systemctl stop mariadb
echo -n "stopping mariadb"
sleep 1; echo -n "."; sleep 1; echo -n "."; sleep 1; echo -n "."; echo ""

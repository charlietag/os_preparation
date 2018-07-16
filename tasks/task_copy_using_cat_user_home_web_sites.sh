_task_check_variable_current_user

local web_sites_name="$(basename $web_sites)"
local config_folder_user_home_web_sites="${CONFIG_FOLDER}/user_home/web_sites"

if [[ ! -d $config_folder_user_home_web_sites ]]; then
  echo "Folder not found: \"${config_folder_user_home_web_sites}\""
  exit
fi

echo "-----------"
echo "copy user_home web_sites config files"
echo "copy all files under ${config_folder_user_home_web_sites}"
echo "including folders"
echo "-----------"
local current_confs=($(find ${config_folder_user_home_web_sites} -type f))
local current_target=""
local current_target_folder=""
for current_conf in ${current_confs[@]}
do
  current_target="${current_user_home}/${web_sites_name}${current_conf/${config_folder_user_home_web_sites}/}"
  current_target_folder="$(dirname $current_target)"

  test -d $current_target_folder || mkdir -p $current_target_folder

  echo "Setting up config file \"${current_target}\"......"
  cat $current_conf > $current_target

  #-- debug use --
  #echo "$current_conf > $current_target"
  #echo ""
done

#-----------------------------------------------------------------------------------------
#Make sure user_home priv is correct
#-----------------------------------------------------------------------------------------
chown -R ${current_user}.${current_user} ${current_user_home}

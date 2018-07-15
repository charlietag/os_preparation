_helper_check_variable_current_user

local config_folder_user_home="${CONFIG_FOLDER}/user_home"

if [[ ! -d $config_folder_user_home ]]; then
  echo "Folder not found: \"${config_folder_user_home}\""
  exit
fi

echo "-----------"
echo "copy user_home config files"
echo "copy all files under ${config_folder_user_home}"
echo "including folders"
echo "-----------"
local current_confs=($(find ${config_folder_user_home} -type f))
local current_target=""
local current_target_folder=""
for current_conf in ${current_confs[@]}
do
  current_target="${current_user_home}${current_conf/${config_folder_user_home}/}"
  current_target_folder="$(dirname $current_target)"

  test -d $current_target_folder || mkdir -p $current_target_folder

  echo "Setting up config file \"${current_target}\"......"
  cat $current_conf > $current_target
done


#-----------------------------------------------------------------------------------------
#Make sure user_home priv is correct
#-----------------------------------------------------------------------------------------
chown -R ${current_user}.${current_user} ${current_user_home}

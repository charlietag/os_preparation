echo "-----------"
echo "copy config files"
echo "copy all files under ${CONFIG_FOLDER} using cat, this means no backup for existing files, just overwrite it!"
echo "including folders"
echo "-----------"
local current_confs=($(find ${CONFIG_FOLDER} -type f))
local current_target=""
local current_target_folder=""
for current_conf in ${current_confs[@]}
do
  current_target="${current_conf/${CONFIG_FOLDER}/}"
  current_target_folder="$(dirname $current_target)"

  test -d $current_target_folder || mkdir -p $current_target_folder

  echo "Setting up config file \"${current_target}\"......"
  cat $current_conf > $current_target
done



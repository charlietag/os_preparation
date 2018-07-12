echo "-----------"
echo "Setup config files"
echo "render all files under ${CONFIG_FOLDERi}"
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

  # use RENDER_CP to fetch var from datadog
  RENDER_CP $current_conf $current_target
done

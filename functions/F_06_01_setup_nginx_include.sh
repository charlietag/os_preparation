#--------------------------
#  Setup nginx sample configs
#--------------------------
echo "-----------"
echo "setup nginx configs include.d"
echo "-----------"
local nginx_confs=($(find ${CONFIG_FOLDER} -type f))
local nginx_target=""
local nginx_target_folder=""
for nginx_conf in ${nginx_confs[@]}
do
  nginx_target="${nginx_conf/${CONFIG_FOLDER}/}"
  nginx_target_folder="$(dirname $nginx_target)"

  test -d $nginx_target_folder || mkdir -p $nginx_target_folder

  # use RENDER_CP to fetch var from datadog
  RENDER_CP $nginx_conf $nginx_target
done


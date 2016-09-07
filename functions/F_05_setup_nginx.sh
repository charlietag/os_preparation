#--------------------------
#  Setup nginx sample configs
#--------------------------
echo "========================================="
echo "      setup nginx configs"
echo "========================================="
local nginx_confs=($(find ${CONFIG_FOLDER} -type f))
local nginx_target=""
local nginx_target_folder=""
for nginx_conf in ${nginx_confs[@]}
do
  nginx_target="$(head -n 1 $nginx_conf | sed 's/^#//')"
  nginx_target_folder="$(dirname $nginx_target)"
  #echo "$nginx_conf"
  #echo "$nginx_target"
  test -d $nginx_target_folder || mkdir -p $nginx_target_folder
  if [ "$(basename $nginx_conf)" == "passenger.conf" ]
  then
    RENDER_CP $nginx_conf $nginx_target
  else
    \cp -a --backup=t $nginx_conf $nginx_target
  fi
done


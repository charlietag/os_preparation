#--------------------------
#  Setup nginx sample configs
#--------------------------
echo "========================================="
echo "      setup nginx configs"
echo "========================================="
local nginx_confs=($(find ${CONFIG_FOLDER} -type f))
local nginx_path=""
for nginx_conf in ${nginx_confs[@]}
do
  nginx_path="$(head -n 1 $nginx_conf | sed 's/^#//')"
  #echo "$nginx_conf"
  #echo "$nginx_path"
  test -d $nginx_path || mkdir -p $nginx_path
  if [ "$(basename $nginx_conf)" == "passenger.conf" ]
  then
    RENDER_CP $nginx_conf $nginx_path
  else
    \cp -a --backup=t $nginx_conf $nginx_path
  fi
done


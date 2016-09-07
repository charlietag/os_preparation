#--------------------------
#  Prepare My Nginx Env
#--------------------------
mkdir /opt_home
useradd -d /opt_home/optnginx -s /sbin/nologin -m -r optnginx
useradd -d /opt_home/optpass -s /sbin/nologin -m -r optpass

#--------------------------
#  Install via ruby gem
#--------------------------
gem install passenger
passenger-install-nginx-module --auto-download --languages ruby --auto

#--------------------------
#  Setup nginx sample configs
#--------------------------
local nginx_confs=($(find ${CONFIG_FOLDER} -type f))
local nginx_path=""
for nginx_conf in ${nginx_confs[@]}
do
  nginx_path="$(head -n 1 $nginx_conf | sed 's/^#//')"
  #echo "$nginx_conf"
  #echo "$nginx_path"
  cp -a $nginx_conf $nginx_path
done

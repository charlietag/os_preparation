#--------------------------
#  Prepare My Nginx Env
#--------------------------

echo "========================================="
echo "      mkdir /opt_home"
echo "========================================="
mkdir /opt_home
echo "========================================="
echo "      add user \"optnginx\", \"optpass\" "
echo "========================================="
useradd -d /opt_home/optnginx -s /sbin/nologin -m -r optnginx
useradd -d /opt_home/optpass -s /sbin/nologin -m -r optpass

#--------------------------
#  Install via ruby gem
#--------------------------
echo "========================================="
echo "      gem install passenger"
echo "========================================="
gem install passenger
echo "========================================="
echo "     passenger-install-nginx-module --auto-download --languages ruby --auto "
echo "========================================="
passenger-install-nginx-module --auto-download --languages ruby --auto

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
  \cp -a --backup=t $nginx_conf $nginx_path
done

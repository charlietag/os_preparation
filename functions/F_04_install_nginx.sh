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

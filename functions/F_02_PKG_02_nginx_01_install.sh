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
#  Install nginx via ruby gem using passenger-install
#--------------------------
echo "========================================="
echo "      gem install passenger"
echo "========================================="
gem install passenger
echo "========================================="
echo "     passenger-install-nginx-module --auto-download --languages ruby --auto "
echo "========================================="
passenger-install-nginx-module --auto-download --languages ruby --auto


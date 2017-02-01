yum install -y MariaDB-server MariaDB-client mariadb-devel

echo "==============================="
echo "        Disable mariadb"
echo "==============================="
chkconfig mysql off # avoid using SysV, use systemd instead
systemctl disable mariadb

echo "==============================="
echo "  Disable mariadb done"
echo "==============================="

echo "==============================="
echo "  Setup mariadb config"
echo "==============================="
# =====================
# Enable databag
# =====================
# RENDER_CP
# Setup bind-address
sed -e '/^bind-address/ s/^#*/#/' -i /etc/my.cnf.d/server.cnf
sed -e "/^\[mysqld\]/a bind-address = ${mariadb_listen_address}" -i /etc/my.cnf.d/server.cnf

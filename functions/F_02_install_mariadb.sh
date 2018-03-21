yum install -y MariaDB-server MariaDB-client mariadb-devel

# This is used for gem mysql2 - espacial MariaDB-shared
yum install -y MariaDB-common MariaDB-compat MariaDB-shared

echo "==============================="
echo "        Disable mariadb"
echo "==============================="
# avoid using SysV, use systemd instead
# Run this several times stupidly to avoid SysV-mysql on suddenly
chkconfig mysql on
chkconfig mysql off
systemctl enable mariadb
systemctl disable mariadb

chkconfig mysql on
chkconfig mysql off
systemctl enable mariadb
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

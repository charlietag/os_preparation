yum install -y MariaDB-server MariaDB-client mariadb-devel

echo "==============================="
echo "        Disable mariadb"
echo "==============================="
chkconfig mysql off # avoid using SysV, use systemd instead
systemctl disable mariadb

echo "==============================="
echo "  Disable mariadb done"
echo "==============================="

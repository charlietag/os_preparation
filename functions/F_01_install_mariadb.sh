yum install -y MariaDB-server MariaDB-client mariadb-devel

echo "==============================="
echo "        Disable mariadb.service"
echo "==============================="
chkconfig mysql off # avoid using SysV, use systemd instead
systemctl disable mariadb.service

echo "==============================="
echo "  Disable mariadb.service done"
echo "==============================="

# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

local pkgs_list=""
echo "==============================="
echo "        Render mariadb repo"
echo "==============================="
task_copy_using_render

#dnf install -y MariaDB-server MariaDB-client mariadb-devel
pkgs_list="${pkgs_list} MariaDB-server MariaDB-client mariadb-devel"

# This is used for gem mysql2 - espacial MariaDB-shared
#dnf install -y MariaDB-common MariaDB-compat MariaDB-shared
pkgs_list="${pkgs_list} MariaDB-common MariaDB-compat MariaDB-shared"

#-----------------------------------------------------------------------------------------
#Package Start to Install
#-----------------------------------------------------------------------------------------
dnf install -y ${pkgs_list}

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


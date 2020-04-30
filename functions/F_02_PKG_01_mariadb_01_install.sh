# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

local pkgs_list=""
echo "==============================="
echo "        Render mariadb repo"
echo "==============================="
if [[ -z "$(dnf repolist mariadb 2>/dev/null)" ]] ; then
  task_copy_using_render
  L_UPDATE_REPO 5000
fi

#dnf install -y MariaDB-server MariaDB-client mariadb-devel
pkgs_list="${pkgs_list} MariaDB-server MariaDB-client MariaDB-devel"

# This is used for gem mysql2 - espacial MariaDB-shared
pkgs_list="${pkgs_list} MariaDB-common MariaDB-shared"

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


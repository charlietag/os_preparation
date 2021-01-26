# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

local pkgs_list=""

#-----------------------------------------------------------------------------------------
# MariaDB official Reop (use dnf module - AppStream instead)
#-----------------------------------------------------------------------------------------
# echo "==============================="
# echo "        Render mariadb repo"
# echo "==============================="
# if [[ -z "$(dnf repolist --enabled 2>&1  | grep 'mariadb')" ]] ; then
#   task_copy_using_render
#   #L_UPDATE_REPO 5000
# fi
#
# #dnf install -y MariaDB-server MariaDB-client mariadb-devel
# pkgs_list="${pkgs_list} MariaDB-server MariaDB-client MariaDB-devel"
#
# # This is used for gem mysql2 - espacial MariaDB-shared
# pkgs_list="${pkgs_list} MariaDB-common MariaDB-shared"

#-----------------------------------------------------------------------------------------
# Packages - dnf module method (AppStream)
#-----------------------------------------------------------------------------------------
# ###########################################################
# For using dnf module
# ###########################################################
# selinux-policy-targeted conflicts with mariadb-server:10.5 (mysql-selinux if selinux-policy-targeted)
dnf remove -y selinux-policy-targeted

# The following packages contain all pkgs in module install mariadb:{version}/server
pkgs_list="${pkgs_list} mariadb mariadb-server"
pkgs_list="${pkgs_list} mariadb-devel mariadb-connector-c-devel"

#-----------------------------------------------------------------------------------------
#Package Start to Install
#-----------------------------------------------------------------------------------------
dnf install -y ${pkgs_list}

echo "==============================="
echo "        Disable mariadb"
echo "==============================="
# avoid using SysV, use systemd instead
# Run this several times stupidly to avoid SysV-mysql on suddenly
echo -e "\n--- chkconfig mysql on ---"
chkconfig mysql on

echo -e "\n--- chkconfig mysql off ---"
chkconfig mysql off

echo -e "\n--- systemctl enable mariadb ---"
systemctl enable mariadb

echo -e "\n--- systemctl disable mariadb ---"
systemctl disable mariadb





echo -e "\n--- chkconfig mysql on ---"
chkconfig mysql on

echo -e "\n--- chkconfig mysql off ---"
chkconfig mysql off

echo -e "\n--- systemctl enable mariadb ---"
systemctl enable mariadb

echo -e "\n--- systemctl disable mariadb ---"
systemctl disable mariadb

echo "==============================="
echo "  Disable mariadb done"
echo "==============================="


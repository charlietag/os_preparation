# =====================
# Enable databag
# =====================
# DATABAG_CFG:disable

#-----------------------------------------------------------------------------------------
# Nginx official Reop (use dnf module - AppStream instead)
#-----------------------------------------------------------------------------------------
# echo "==============================="
# echo "        Render nginx repo"
# echo "==============================="
# if [[ -z "$(dnf repolist --enabled 2>&1 | grep 'nginx-stable')" ]] ; then
#   #task_copy_using_render
#   task_copy_using_cat
#   #L_UPDATE_REPO 5000
# fi

# ###########################################################
# Install Nginx
# ###########################################################
dnf install -y nginx

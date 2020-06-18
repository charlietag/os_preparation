# =====================
# Enable databag
# =====================
# DATABAG_CFG:disable

echo "==============================="
echo "        Render nginx repo"
echo "==============================="
if [[ -z "$(dnf repolist --enabled 2>&1 | grep 'nginx-stable')" ]] ; then
  #task_copy_using_render
  task_copy_using_cat
  #L_UPDATE_REPO 5000
fi

dnf install -y nginx

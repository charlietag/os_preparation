# =====================
# Enable databag
# =====================
# DATABAG_CFG:disable

echo "==============================="
echo "        Render nginx repo"
echo "==============================="
if [[ -z "$(dnf repolist nginx-stable 2>/dev/null)" ]] ; then
  #task_copy_using_render
  task_copy_using_cat
  L_UPDATE_REPO 5000
fi

dnf install -y nginx

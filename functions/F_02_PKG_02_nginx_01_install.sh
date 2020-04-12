# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

echo "==============================="
echo "        Render nginx repo"
echo "==============================="
task_copy_using_render

dnf install -y nginx

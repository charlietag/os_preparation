# =====================
# Enable databag
# =====================
# RENDER_CP

echo "==============================="
echo "        Render nginx repo"
echo "==============================="
task_copy_using_render

yum install -y nginx

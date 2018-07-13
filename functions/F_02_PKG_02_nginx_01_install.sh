# =====================
# Enable databag
# =====================
# RENDER_CP

echo "==============================="
echo "        Render nginx repo"
echo "==============================="
helper_copy_using_render

yum install -y nginx

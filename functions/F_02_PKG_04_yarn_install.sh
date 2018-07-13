# =====================
# Enable databag
# =====================
# RENDER_CP

#Yarn
curl "${yarn_yum_repo}" -o /etc/yum.repos.d/yarn.repo

#For Rails 5.1+ , which is supporting yarn
yum install -y yarn

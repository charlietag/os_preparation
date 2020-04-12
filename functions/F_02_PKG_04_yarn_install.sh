# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

#Yarn
curl "${yarn_dnf_repo}" -o /etc/yum.repos.d/yarn.repo

#For Rails 5.1+ , which is supporting yarn
dnf install -y yarn

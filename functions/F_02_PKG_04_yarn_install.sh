# =====================
# Enable databag
# =====================
# DATABAG_CFG:disable

# Make sure NodeJs is installed
if ! $(command -v npm > /dev/null); then
  echo "NodeJS is not installed correctly !!!"
  echo ""
  exit
fi

#----------------------------------------
# Yarn 1.22.x , classic , yum/dnf repo
#----------------------------------------
# curl "${yarn_dnf_repo}" -o /etc/yum.repos.d/yarn.repo
# dnf install -y yarn

#----------------------------------------
# Yarn 2.x
#----------------------------------------
#For Rails 5.1+ , which is supporting yarn
npm install -g yarn

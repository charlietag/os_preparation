#-----------------------------------------------------------------------------------------
# YUM Repo
#-----------------------------------------------------------------------------------------
local centos_repo="/etc/yum.repos.d/"
local repo_fail=0
local repos=(webtatic MariaDB node)

# =============================
# check repo exists function
# =============================
check_repo_exist (){
  for repo in ${repos[@]}
  do
    if [ -z "$(ls $centos_repo |grep -E "${repo}")" ]
    then
      echo "failed to find repo \"${repo}\""
      repo_fail=1
    fi
  done
}

# =============================
#Make sure repo exists before running
# =============================
repo_fail=0
check_repo_exist

# =============================
# Install repo if not exists
# =============================
if [ $repo_fail -eq 1 ]
then
  #PHP 7
  rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

  #NodeJS 6
  curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -

  #MariaDB
  cp -a $CONFIG_FOLDER/etc/yum.repos.d/*.repo $centos_repo
fi

# =============================
#Make sure repo exists before running
# =============================
repo_fail=0
check_repo_exist
if [ $repo_fail -eq 1 ]
then
  echo "Some repo is not installed properly!"
  exit
fi

# =============================
# Clean yum repo
# =============================
yum clean all


#-----------------------------------------------------------------------------------------
# YUM Repo
#-----------------------------------------------------------------------------------------
local centos_repo="/etc/yum.repos.d/"
local repos=($(ls $centos_repo |grep -E "webtatic|MariaDB|node"))

# Install repo if not exists
if [ -z "${repos}" ]
then
  #PHP 7
  rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

  #NodeJS 6
  curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -

  #MariaDB
  cp -a $CONFIG_FOLDER/yum_repo/*.repo $centos_repo
fi

#Make sure repo exists before running
repos=($(ls $centos_repo |grep -E "webtatic|MariaDB|node"))
if [ -z "${repos}" ]
then
  echo "Some repos not exists!"
  exit
fi

# Clean yum repo
yum clean all


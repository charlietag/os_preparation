#-----------------------------------------------------------------------------------------
# YUM Repo
#-----------------------------------------------------------------------------------------
#PHP 7
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

#NodeJS 6
curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -

#MariaDB
CENTOS_REPO="/etc/yum.repos.d/"
cp $CONFIG_FOLDER/yum_repo/*.repo $CENTOS_REPO

#Make sure repo exists before running
REPOS=($(ls $CENTOS_REPO |grep -E "webtatic|MariaDB|node"))
if [ -z "${REPOS}" ]
then
  echo "Some repos not exists!"
  exit
fi

#-----------------------------------------------------------------------------------------
#SELINUX OFF
#-----------------------------------------------------------------------------------------
sed -i s/'SELINUX=enforcing'/'SELINUX=disabled'/ /etc/selinux/config

#-----------------------------------------------------------------------------------------
#Package Install
#-----------------------------------------------------------------------------------------
yum install -y nodejs
yum remove -y chrony
yum groupinstall -y "Development Tools"
yum install -y bash redhat-lsb screen git vim ntpdate sysstat mtr net-tools wget openssl-devel bind-utils


#For Rails
# rpm --quiet -q sqlite-devel || yum -y install sqlite-devel   # use mysql not sqlite
#rpm --quiet -q mariadb-devel || yum -y install mariadb-devel

#For Passenger
yum -y install curl-devel

#For compile latest ruby
yum install -y libffi-devel libyaml-devel readline-devel zlib zlib-devel tk-devel dotconf-devel valgrind-devel graphviz-devel jemalloc-devel

# For sql server connection (freetds)
yum install freetds freetds-devel openssl openssl-libs openssl-devel libticonv-devel -y


#-----------------------------------------------------------------------------------------
#Setup ntpdate
#-----------------------------------------------------------------------------------------
#sed -i /ntpdate/d /etc/crontab ; echo "*/5 * * * * root ntpdate clock.stdtime.gov.tw >/dev/null 2>/dev/null" >> /etc/crontab
sed -i /ntpdate/d /etc/crontab ; echo "*/5 * * * * root ntpdate pool.ntp.org >/dev/null 2>/dev/null" >> /etc/crontab

#-----------------------------------------------------------------------------------------
#Firewall OFF
#-----------------------------------------------------------------------------------------
systemctl disable firewalld.service

#-----------------------------------------------------------------------------------------
#Service OFF
#-----------------------------------------------------------------------------------------
systemctl disable postfix
systemctl disable NetworkManager

#-----------------------------------------------------------------------------------------
#Solve sshd login waiting issue (GSSAuth)
#-----------------------------------------------------------------------------------------
sed -i s/'#GSSAPIAuthentication yes'/'GSSAPIAuthentication no'/ /etc/ssh/sshd_config
sed -i s/'GSSAPIAuthentication yes'/'#GSSAPIAuthentication yes'/ /etc/ssh/sshd_config
# Disable sshd acceptenv
sed -e '/^AcceptEnv/ s/^#*/#/' -i /etc/ssh/sshd_config

#-----------------------------------------------------------------------------------------
#Self Customize /root/.all
#-----------------------------------------------------------------------------------------
rm -fr ~/.vim

FILES=($(ls -a $CONFIG_FOLDER | grep -E "^\."))
for FILE in ${FILES[@]}
do
  test -f ~/$FILE && rm -f ~/$FILE
  cp $CONFIG_FOLDER/$FILE ~/$FILE
done

#-----------------------------------------------------------------------------------------
#Setup Vim Setting
#-----------------------------------------------------------------------------------------
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

cd ~/.vim/bundle
git clone git://github.com/godlygeek/tabular.git
git clone https://github.com/Raimondi/delimitMate.git
git clone https://github.com/scrooloose/nerdtree.git
git clone https://github.com/vim-airline/vim-airline.git
#git clone https://github.com/vim-airline/vim-airline-themes

#Show git branch name
git clone git://github.com/tpope/vim-fugitive.git
#git clone git://github.com/airblade/vim-gitgutter.git
cd $CURRENT_FOLDER

#-----------------------------------------------------------------------------------------
#Finish and Reboot
#-----------------------------------------------------------------------------------------
sync;sync;sync;
echo "------------------------------------------------"
echo "   Environments setup successful"
echo "------------------------------------------------"
echo ""
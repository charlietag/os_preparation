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

#-----------------------------------------------------------------------------------------
#SELINUX OFF
#-----------------------------------------------------------------------------------------
sed -i s/'SELINUX=enforcing'/'SELINUX=disabled'/ /etc/selinux/config

#-----------------------------------------------------------------------------------------
# NTP update date time and hwclock to prevent mariadb cause systemd warning
#-----------------------------------------------------------------------------------------
yum remove -y chrony
yum install -y ntpdate
ntpdate pool.ntp.org
hwclock -w


#-----------------------------------------------------------------------------------------
#Package Install
#-----------------------------------------------------------------------------------------
yum install -y nodejs
yum groupinstall -y "Development Tools"
yum install -y bash redhat-lsb screen git tree vim sysstat mtr net-tools wget openssl-devel bind-utils


#For Rails
# rpm --quiet -q sqlite-devel || yum -y install sqlite-devel   # use mysql not sqlite
# rpm --quiet -q mariadb-devel || yum -y install mariadb-devel

#For Passenger
yum -y install curl-devel

#For compile latest ruby
yum install -y libffi-devel libyaml-devel readline-devel zlib zlib-devel tk-devel dotconf-devel valgrind-devel graphviz-devel jemalloc-devel

# For sql server connection (freetds)
yum install freetds freetds-devel openssl openssl-libs openssl-devel libticonv-devel -y


#-----------------------------------------------------------------------------------------
#Setup ntpdate
#-----------------------------------------------------------------------------------------
sed -i /ntpdate/d /etc/crontab
echo "*/5 * * * * root ntpdate pool.ntp.org >/dev/null 2>/dev/null ; hwclock -w  >/dev/null 2>/dev/null" >> /etc/crontab

#echo "*/5 * * * * root ntpdate clock.stdtime.gov.tw >/dev/null 2>/dev/null" >> /etc/crontab

#-----------------------------------------------------------------------------------------
#Firewall OFF
#-----------------------------------------------------------------------------------------
systemctl disable firewalld.service

#-----------------------------------------------------------------------------------------
#Service OFF
#-----------------------------------------------------------------------------------------
systemctl disable postfix
systemctl disable NetworkManager
systemctl disable avahi-daemon.socket
systemctl disable avahi-daemon.service

#-----------------------------------------------------------------------------------------
#Solve sshd login waiting issue (GSSAuth)
#-----------------------------------------------------------------------------------------
sed -i s/'#GSSAPIAuthentication yes'/'GSSAPIAuthentication no'/ /etc/ssh/sshd_config
sed -i s/'GSSAPIAuthentication yes'/'#GSSAPIAuthentication yes'/ /etc/ssh/sshd_config
# Disable sshd acceptenv
sed -e '/^AcceptEnv/ s/^#*/#/' -i /etc/ssh/sshd_config

# Disable sshd UseDNS
sed -i '/UseDNS/d' /etc/ssh/sshd_config
echo "UseDNS no" >> /etc/ssh/sshd_config

# =====================
# Enable databag
# =====================
# RENDER_CP

# Change listen port
sed -i '/Port /d' /etc/ssh/sshd_config
echo "Port ${ssh_listen_port}" >> /etc/ssh/sshd_config

# Change listen address
sed -i '/ListenAddress /d' /etc/ssh/sshd_config
echo "ListenAddress ${ssh_listen_address}" >> /etc/ssh/sshd_config


#-----------------------------------------------------------------------------------------
#Self Customize /root/.all
#-----------------------------------------------------------------------------------------
local files=($(ls -a $CONFIG_FOLDER/home_setting | grep -E "^\.[A-Za-z0-9_]+$"))
for file in ${files[@]}
do
  rm -rf ${HOME}/$file
  cp -a $CONFIG_FOLDER/home_setting/$file ${HOME}/$file
done
RENDER_CP $CONFIG_FOLDER/home_setting/.gitconfig ${HOME}/.gitconfig
test -f /etc/screenrc && mv /etc/screenrc /etc/screenrc.bak

#-----------------------------------------------------------------------------------------
#Setup Vim Setting
#-----------------------------------------------------------------------------------------
mkdir -p ${HOME}/.vim/autoload ${HOME}/.vim/bundle && \
curl -LSso ${HOME}/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

cd ${HOME}/.vim/bundle
git clone git://github.com/godlygeek/tabular.git
git clone https://github.com/Raimondi/delimitMate.git
git clone https://github.com/scrooloose/nerdtree.git
git clone https://github.com/vim-airline/vim-airline.git
#git clone https://github.com/vim-airline/vim-airline-themes

#Show git branch name
git clone git://github.com/tpope/vim-fugitive.git
#git clone git://github.com/airblade/vim-gitgutter.git

#-----------------------------------------------------------------------------------------
# etc/hostname for hostname setup
#-----------------------------------------------------------------------------------------
# hostname
RENDER_CP $CONFIG_FOLDER/etc_hostname /etc/hostname
hostname -F /etc/hostname
# nameserver
RENDER_CP $CONFIG_FOLDER/etc_resolv.conf /etc/resolv.conf
# Disable IPv6
RENDER_CP $CONFIG_FOLDER/etc_sysctl.conf /etc/sysctl.conf
sysctl -p


#-----------------------------------------------------------------------------------------
#Finish and Reboot
#-----------------------------------------------------------------------------------------
sync;sync;sync;
echo "------------------------------------------------"
echo "   Environments setup successful"
echo "------------------------------------------------"
echo ""

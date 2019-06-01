echo "==============================="
echo "        Render repo"
echo "==============================="
yum install -y epel-release

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
# For NodeJS
yum install -y gcc-c++ make

# Basic dev packages
yum groupinstall -y "Development Tools"
yum install -y jwhois bash redhat-lsb screen git tree vim sysstat mtr net-tools wget openssl-devel bind-utils

# Basic debug tools - Enhanced tail / Enhanced grep
yum install -y multitail ack

#For Rails (also for rvm)
rpm --quiet -q sqlite-devel || yum -y install sqlite-devel   # use mysql not sqlite

#For Passenger
#yum install -y curl-devel

#For compile latest ruby
yum install -y libffi-devel libyaml-devel readline-devel zlib zlib-devel tk-devel dotconf-devel valgrind-devel graphviz-devel jemalloc-devel

#For RVM 1.29.8 - Add system ruby as dependency for CentOS
yum install -y ruby

# For SSL
yum install -y openssl openssl-libs openssl-devel libticonv-devel

# For sql server connection (freetds)
yum install -y freetds freetds-devel 

# ImageMagick6 - For rails 5.2+, active storage (gem 'mini_magick')
local image_magick_packages="$(curl -s https://imagemagick.org/download/linux/CentOS/x86_64/ |grep -Eo '"(ImageMagick-|ImageMagick-devel-|ImageMagick-libs-)+6.(\S)+(\.rpm)"' |xargs -i bash -c "echo https://imagemagick.org/download/linux/CentOS/x86_64/{}" | sed ':a;N;$!ba;s/\n/ /g')"
yum localinstall -y ${image_magick_packages}

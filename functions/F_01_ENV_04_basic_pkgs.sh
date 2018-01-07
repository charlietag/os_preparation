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
# NodeJS
yum install -y nodejs
yum install -y gcc-c++ make

# Basic dev packages
yum groupinstall -y "Development Tools"
yum install -y bash redhat-lsb screen git tree vim sysstat mtr net-tools wget openssl-devel bind-utils


#For Rails
# rpm --quiet -q sqlite-devel || yum -y install sqlite-devel   # use mysql not sqlite
# rpm --quiet -q mariadb-devel || yum -y install mariadb-devel # Move this step to mariadb installation function

#For Rails 5.1, which is supporting yarn
yum install -y yarn

#For Passenger
yum install -y curl-devel

#For compile latest ruby
yum install -y libffi-devel libyaml-devel readline-devel zlib zlib-devel tk-devel dotconf-devel valgrind-devel graphviz-devel jemalloc-devel

# For sql server connection (freetds)
yum install -y freetds freetds-devel openssl openssl-libs openssl-devel libticonv-devel


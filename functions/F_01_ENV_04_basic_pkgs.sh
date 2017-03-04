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


#!/bin/bash
#****************
#* Choose "Minimal Server" during the intstallation (works With Minimal ISO)
#****************
#-----------------------------------------------------------------------------------------
#SELINUX OFF
#-----------------------------------------------------------------------------------------
sed -i s/'SELINUX=enforcing'/'SELINUX=disabled'/ /etc/selinux/config

#-----------------------------------------------------------------------------------------
#Package Install
#-----------------------------------------------------------------------------------------
# make sure bash is the latest version
yum install bash -y

yum groupinstall "Development Tools"

rpm --quiet -q redhat-lsb || yum install -y redhat-lsb
rpm --quiet -q screen || yum install -y screen
rpm --quiet -q vsftpd || yum install -y vsftpd
rpm --quiet -q git || yum install -y git
rpm --quiet -q vim || yum install -y vim
rpm --quiet -q ntpdate || yum install -y ntpdate
rpm --quiet -q sysstat || yum install -y sysstat
rpm --quiet -q mtr || yum install -y mtr
rpm --quiet -q net-tools || yum install -y net-tools
rpm --quiet -q wget || yum install -y wget
rpm --quiet -q openssl-devel || yum -y install openssl-devel
rpm --quiet -q bind-utils || yum -y install bind-utils

#For Laravel (Install later while installing php-fpm)
# rpm --quiet -q php70w-xml || yum -y install php70w-xml

#For Rails
# rpm --quiet -q sqlite-devel || yum -y install sqlite-devel   # use mysql not sqlite
rpm --quiet -q mariadb-devel || yum -y install mariadb-devel

#For Passenger
rpm --quiet -q curl-devel || yum -y install curl-devel

#For compile latest ruby
rpm --quiet -q libffi-devel || yum -y install libffi-devel
rpm --quiet -q libyaml-devel || yum -y install libyaml-devel
rpm --quiet -q readline-devel || yum -y install readline-devel

rpm --quiet -q zlib || yum -y install zlib
rpm --quiet -q zlib-devel || yum -y install zlib-devel

rpm --quiet -q chrony && yum -y remove chrony

yum install tk-devel dotconf-devel valgrind-devel graphviz-devel jemalloc-devel -y

# For sql server connection (freetds)
#yum install freetds freetds-devel openssl openssl-libs openssl-devel libticonv-devel -y


#yum install -y tigervnc*
#yum install -y vsftpd

#sed -i s/^root/'#root'/g /etc/vsftpd/ftpusers
#sed -i s/^root/'#root'/g /etc/vsftpd/user_list
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

#-----------------------------------------------------------------------------------------
#Self Customize (.bashrc)
#-----------------------------------------------------------------------------------------
cat ~/.bashrc|grep -q 'alias c=' || echo "alias c='clear'" >> ~/.bashrc
cat ~/.bashrc|grep -q "alias grep" || echo "alias grep='grep --color=auto'" >> ~/.bashrc
cat ~/.bashrc|grep -q "alias ll" || echo "alias ll='ls -alh'" >> ~/.bashrc
cat ~/.bashrc|grep -q "alias l=" || echo "alias l='ls -lh'" >> ~/.bashrc
cat ~/.bashrc|grep -q "alias v=" || echo "alias v='vim +\"colorscheme lucid\"'" >> ~/.bashrc
cat ~/.bashrc|grep -q 'alias vv=' || echo "alias vv='vim -u /dev/null'" >> ~/.bashrc

cat ~/.bashrc|grep -q "alias o=" || echo "alias o='cd ..'" >> ~/.bashrc
cat ~/.bashrc|grep -q "alias oo=" || echo "alias oo='cd ../..'" >> ~/.bashrc
cat ~/.bashrc|grep -q "alias ooo=" || echo "alias ooo='cd ../../..'" >> ~/.bashrc
cat ~/.bashrc|grep -q "alias b=" || echo "alias b='cd -'" >> ~/.bashrc

cat ~/.bashrc|grep -q "alias be=" || echo "alias be='bundle exec'" >> ~/.bashrc
cat ~/.bashrc|grep -q "alias bk=" || echo "alias bk='bundle exec rake'" >> ~/.bashrc
cat ~/.bashrc|grep -q "alias bl=" || echo "alias bl='bundle exec rails'" >> ~/.bashrc

cat ~/.bashrc|grep -q "HISTSIZE" || echo "HISTSIZE=1000000" >> ~/.bashrc
cat ~/.bashrc|grep -q "HISTTIMEFORMAT" || echo "export HISTTIMEFORMAT='%F %T '" >> ~/.bashrc

# For screen 4.1 to disable hostname in caption
cat ~/.bashrc|grep -q "PROMPT_COMMAND" || echo "unset PROMPT_COMMAND" >> ~/.bashrc

echo -e "\n\n\n" >> ~/.bashrc
# For git function
cat ~/.bashrc|grep -q "parse_git_dirty" || echo "
# Git Function

#CentOS6 bash git status usage
function parse_git_dirty_branch {
  [[ \$(git status 2> /dev/null | tail -n1) != \"nothing to commit, working directory clean\" ]] && echo -e \"\033[01;31m\$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e \"s/* \(.*\)/(\1)/\")\" || echo -e \"\033[1;32m\$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e \"s/* \(.*\)/(\1)/\")\"
}

#CentOS7 bash git status usage
function git_since_last_commit {
    LAST_COMMIT=\$(git log --pretty=format:%ar -1 2> /dev/null)
    [[ ! -z \"\${LAST_COMMIT}\" ]] && echo \"(\${LAST_COMMIT})\"
}
" >> ~/.bashrc

# For PS1 console (31m -> RED prompt, 32m GREEN 33m YELLOW)
cat ~/.bashrc |grep -q "PS1=" || echo "PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\$(parse_git_dirty_branch)\[\e[0;33m\]\$(git_since_last_commit)\[\033[00m\]\\n# '" >> ~/.bashrc
#++++++++++++
#vim scheme +
#:colorscheme desert
#:colorscheme elflord
#:colorscheme koehler
#:colorscheme ron
#:colorscheme torte <--- Best
#:colorscheme 256-jungle
#:colorscheme lucid
#:colorscheme motus
#/usr/share/vim/vim72/colors
#++++++++++++
test -d ~/.vim && rm -fr ~/.vim

# for ruby gem install without making docment (no-ri, no-rdoc are deprecated)
#echo "gem: --no-document" > ~/.gemrc
#-----------------------------------------------------------------------------------------
#Finish and Reboot
#-----------------------------------------------------------------------------------------
sync;sync;sync;
echo "Successful......"
#echo "System is rebooting in 3 seconds....."
#sleep 3
#reboot

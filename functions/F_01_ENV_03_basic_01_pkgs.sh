local pkgs_list=""
echo "==============================="
echo "  Installing basic dev packages..."
echo "==============================="

## No need package "yum-utils" for these commands #===> instead, using "dnf-plugins-core" , installed by default minimal installation
#  dnf config-manager --set-enabled PowerTools
#  dnf repoquery -l vsftpd  #===> equals to `rpm -ql vsftpd`


[[ -z "$(dnf repolist PowerTools 2>/dev/null)" ]] && dnf config-manager --set-enabled PowerTools

# To make sure epel-modular is OK (var is ok , ?repo=epel-modular-$releasever&arch=$basearch&infra=$infra&content=$contentdir , /etc/dnf/vars)
#  ref. https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/sec-using_yum_variables
rpm --quiet -q epel-release || dnf install -y yum-utils epel-release

# --- epel-modular seems so slow, sometimes even failed to connect ---
# But this is for dnf module install xxxx... cannot be disabled #===> comment out
#dnf config-manager --set-disabled epel-modular

# --- Make sure dnf cached file is updated ---
# The following command means : "dnf clean all ; dnf repolist", and will retry 5000 times if fails

# UPDATE retry 5000 by default
L_UPDATE_REPO 5000

#-----------------------------------------------------------------------------------------
# NTP update date time and hwclock to prevent mariadb cause systemd warning
#-----------------------------------------------------------------------------------------
pkgs_list="${pkgs_list} chrony"


#-----------------------------------------------------------------------------------------
#Package Install
#-----------------------------------------------------------------------------------------
# For NodeJS
#dnf install -y gcc-c++ make
pkgs_list="${pkgs_list} gcc-c++ make"

# Basic dev packages
dnf groupinstall -y "Development Tools"
#dnf install -y whois bash redhat-lsb screen git tree vim sysstat mtr net-tools wget openssl-devel bind-utils
pkgs_list="${pkgs_list} whois bash redhat-lsb screen git tree vim sysstat mtr net-tools wget openssl-devel bind-utils"

# Basic debug tools - Enhanced tail / Enhanced grep
#dnf install -y multitail ack
pkgs_list="${pkgs_list} multitail ack"

# For SSL
#dnf install -y openssl openssl-libs openssl-devel libticonv-devel
pkgs_list="${pkgs_list} openssl openssl-libs openssl-devel"

# For sql server connection (freetds)
#dnf install -y freetds freetds-devel 
pkgs_list="${pkgs_list} freetds freetds-devel"


#-----------------------------------------------------------------------------------------
#Package Start to Install
#-----------------------------------------------------------------------------------------
dnf install -y ${pkgs_list}

chronyd -q 'pool pool.ntp.org iburst'

systemctl stop chronyd
systemctl disable chronyd

hwclock -w

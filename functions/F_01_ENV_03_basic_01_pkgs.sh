local pkgs_list=""
echo "==============================="
echo "  Installing basic dev packages..."
echo "==============================="

dnf config-manager --set-enabled PowerTools
dnf install -y epel-release

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
#dnf install -y jwhois bash redhat-lsb screen git tree vim sysstat mtr net-tools wget openssl-devel bind-utils
pkgs_list="${pkgs_list} jwhois bash redhat-lsb screen git tree vim sysstat mtr net-tools wget openssl-devel bind-utils"

# Basic debug tools - Enhanced tail / Enhanced grep
#dnf install -y multitail ack
pkgs_list="${pkgs_list} multitail ack"

# For SSL
#dnf install -y openssl openssl-libs openssl-devel libticonv-devel
pkgs_list="${pkgs_list} openssl openssl-libs openssl-devel libticonv-devel"

# For sql server connection (freetds)
#dnf install -y freetds freetds-devel 
pkgs_list="${pkgs_list} freetds freetds-devel"


#-----------------------------------------------------------------------------------------
#Package Start to Install
#-----------------------------------------------------------------------------------------
dnf install -y ${pkgs_list}
ntpdate pool.ntp.org
hwclock -w

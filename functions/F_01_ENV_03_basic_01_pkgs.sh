local pkgs_list=""
echo "==============================="
echo "  Installing basic dev packages..."
echo "==============================="

## No need package "yum-utils" for these commands #===> instead, using "dnf-plugins-core" , installed by default minimal installation
#  dnf config-manager --set-enabled PowerTools
#  dnf repoquery -l vsftpd  #===> equals to `rpm -ql vsftpd`

# ----------------------------------------------------------------------------------------
# Install most required packages first
# ----------------------------------------------------------------------------------------
dnf install -y dnf-plugins-core yum-utils

# ----------------------------------------------------------------------------------------
# Enable repo PowerTools
# ----------------------------------------------------------------------------------------
# check repo
local verify_repo="$(dnf repolist PowerTools 2>&1  | grep 'PowerTools' | grep 'disabled' )"
      verify_repo="$([[ -n "${verify_repo}" ]] && echo "FAILED")"

if [[ "${verify_repo}" = "FAILED" ]]; then
  dnf config-manager --set-enabled PowerTools
  #L_UPDATE_REPO 5000
fi

# ----------------------------------------------------------------------------------------
# Install epel-release
# ----------------------------------------------------------------------------------------
# check package
local verify_pkgs="$(rpm --quiet -q epel-release || echo "FAILED")"
if [[ "${verify_pkgs}" = "FAILED" ]]; then
  # To make sure epel-modular is OK (var is ok , ?repo=epel-modular-$releasever&arch=$basearch&infra=$infra&content=$contentdir , /etc/dnf/vars)
  #  ref. https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/sec-using_yum_variables
  dnf install -y epel-release

  # --- epel-modular seems so slow, sometimes even failed to connect ---
  # But this is for dnf module install xxxx... cannot be disabled #===> comment out
  #dnf config-manager --set-disabled epel-modular

  # --- Make sure dnf cached file is updated ---
  # The following command means : "dnf clean all ; dnf repolist", and will retry 5000 times if fails

  # UPDATE retry 5000 by default
  L_UPDATE_REPO 5000
fi

#-----------------------------------------------------------------------------------------
# NTP update date time and hwclock to prevent mariadb cause systemd warning
#-----------------------------------------------------------------------------------------
pkgs_list="${pkgs_list} chrony"


#-----------------------------------------------------------------------------------------
#Package Install
#-----------------------------------------------------------------------------------------
# For NodeJS
pkgs_list="${pkgs_list} gcc-c++ make"

# Basic dev packages
dnf groupinstall -y "Development Tools"

# whois will not be found in CentOS 8.1 or EPEL, because it is moved into CentOS 8.2, waiting for 8.2 then -> CentOS 8.2 is released...
pkgs_list="${pkgs_list} whois"
pkgs_list="${pkgs_list} bash redhat-lsb screen git tree vim sysstat mtr net-tools wget bind-utils"

# Basic debug tools - Enhanced tail / Enhanced grep
pkgs_list="${pkgs_list} multitail ack"

# For SSL
pkgs_list="${pkgs_list} openssl openssl-libs openssl-devel"

# For sql server connection (freetds)
pkgs_list="${pkgs_list} freetds freetds-devel"

# For GeoIP purpose
pkgs_list="${pkgs_list} GeoIP GeoIP-devel"

# For Nginx HTTP rewrite module
pkgs_list="${pkgs_list} pcre pcre-devel"



#-----------------------------------------------------------------------------------------
#Package Start to Install
#-----------------------------------------------------------------------------------------
dnf install -y ${pkgs_list}

# make sure chronyd stop first , before syncing time using chronyd command!
systemctl stop chronyd
systemctl disable chronyd
chronyd -q 'pool pool.ntp.org iburst'

hwclock -w

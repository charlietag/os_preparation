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
#SELINUX OFF
#-----------------------------------------------------------------------------------------
sed -i s/'SELINUX=enforcing'/'SELINUX=disabled'/ /etc/selinux/config

#-----------------------------------------------------------------------------------------
#Setup timezone
#-----------------------------------------------------------------------------------------
# =====================
# Enable databag
# =====================
# RENDER_CP
timedatectl set-timezone "${current_timezone}"

#-----------------------------------------------------------------------------------------
#Setup ntpdate
#-----------------------------------------------------------------------------------------
sed -i /ntpdate/d /etc/crontab
echo "*/5 * * * * root ntpdate pool.ntp.org >/dev/null 2>/dev/null ; hwclock -w  >/dev/null 2>/dev/null" >> /etc/crontab

#echo "*/5 * * * * root ntpdate clock.stdtime.gov.tw >/dev/null 2>/dev/null" >> /etc/crontab


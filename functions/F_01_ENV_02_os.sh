# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

#-----------------------------------------------------------------------------------------
# etc/hostname for hostname setup
#-----------------------------------------------------------------------------------------
# hostname
# -------------------
#RENDER_CP $CONFIG_FOLDER/etc/hostname /etc/hostname
#hostname -F /etc/hostname
# -------------------
# comment 2 steps above, use hostnamectl command instead
# After setting up hostname to none 'localhosaaat.localdomain'
#   |__ will avoid /etc/resolv.conf contains search localdomain everytime reboot
hostnamectl set-hostname ${host_name}

# set ethernet card PEERDNS to "no" , avoid DHCP modify /etc/resolv.conf
local eth_cards="$(ls /etc/sysconfig/network-scripts/ifcfg-* |grep -v "lo$")"
for eth_card in $eth_cards
do
  sed -i /PEERDNS/d $eth_card
  echo "PEERDNS=\"no\"" >> $eth_card
done

# nameserver
RENDER_CP $CONFIG_FOLDER/etc/resolv.conf /etc/resolv.conf

# Disable IPv6
RENDER_CP $CONFIG_FOLDER/etc/sysctl.conf /etc/sysctl.conf
sysctl -p

#-----------------------------------------------------------------------------------------
#SELINUX OFF
#-----------------------------------------------------------------------------------------
# Disable SELINUX temporary
setenforce 0
# Disable SELINUX permanently
sed -i s/'SELINUX=enforcing'/'SELINUX=disabled'/ /etc/selinux/config

#-----------------------------------------------------------------------------------------
#Setup timezone
#-----------------------------------------------------------------------------------------
timedatectl set-timezone "${current_timezone}"

#-----------------------------------------------------------------------------------------
#Setup chrony
#-----------------------------------------------------------------------------------------
sed -i /chronyd/d /etc/crontab
echo '*/5 * * * * root chronyd -q "pool pool.ntp.org iburst" >/dev/null 2>/dev/null ; hwclock -w  >/dev/null 2>/dev/null' >> /etc/crontab

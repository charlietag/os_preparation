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

# render os config (NetworkManager, sysctl.d)
task_copy_using_render_sed

# set ethernet card PEERDNS to "no" , avoid DHCP modify /etc/resolv.conf
local eth_cards="$(ls /etc/sysconfig/network-scripts/ifcfg-* |grep -v "lo$")"
for eth_card in $eth_cards
do
  # avoid /etc/resolv.conf being changed by NM
  sed -re '/DNS[[:digit:]]+=/d' -i $eth_card
  sed -i /PEERDNS/d $eth_card

  echo "PEERDNS=\"no\"" >> $eth_card
  echo "IPV6_PEERDNS=\"no\"" >> $eth_card

  # Totally disable IPV6
  if [[ $disable_ipv6 -eq 1 ]] ; then
    sed -i /IPV6/d $eth_card
    echo "
      #####IPV6#####
      IPV6_DISABLED=yes
      IPV6INIT=no
      IPV6_DEFROUTE=no
      IPV6_FAILURE_FATAL=no
      IPV6_ADDR_GEN_MODE=stable-privacy
      IPV6_AUTOCONF=no
      IPV6_PEERDNS=no
      IPV6_PEERROUTES=no
      #####IPV6#####
    " | sed -r -e '/^\s*$/d' -e 's/\s+//g' >> $eth_card
  fi


  # Avoid config NetworkManager is not activated immediately
  # NetworkManager is like puma app server, you launch software NetworkManager , does not mean you trigger ifcfg reloaded
  local if_device="$(grep DEVICE ${eth_card} | cut -d'=' -f2)"
  ifdown $eth_card ; ifup $eth_card
done



# Activate config
sysctl -p /etc/sysctl.d/z_custom_sysctl.conf
systemctl restart NetworkManager

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

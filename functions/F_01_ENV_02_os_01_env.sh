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
# After setting up hostname to none 'localhost.localdomain'
#   |__ will avoid /etc/resolv.conf contains search localdomain everytime reboot
hostnamectl set-hostname ${host_name}


#-----------------------------------------------------------------------------------------
# NetworkManager (NM)
#-----------------------------------------------------------------------------------------
#* NM is like puma in-memory config , you change config file, you `nmcli c reload` to load it into in-memory config, but you want to reactivate this config,
#  * you need to `nmcli n off; nmcli n on`
#  * or `nmcli c down ethxxx; nmcli c up ethxxx`
#
#* NM is like X-server, you stop it , does not mean your action will be trigger, restart NM , just like you stop NM-GUI, it will not trigger stop eth, or restart eth
#* nmcli
#  * setup network config file
#  * reload network config file in to NM service (sometimes this will trigger networking restart)
#* nmtui
#  * setup network config file
#  * will NOT reload network config file in to NM service
#* nmcli n off; nmcli n on
#  * Stop and start NM networking management
#* nmcli c down enp0s3 ; nmcli c up enp0s3
#  * Stop and start connection config enp0s3

# --- Using nmcli , instead of any other network tools or commands ---

# render os config (NetworkManager-disable dns config overwrite, sysctl.d-disable ipv6)
task_copy_using_render_sed

# set ethernet card PEERDNS to "no" , avoid DHCP modify /etc/resolv.conf
local eth_cards="$(ls /etc/sysconfig/network-scripts/ifcfg-* |grep -v "lo$")"
for eth_card in $eth_cards
do
  # avoid /etc/resolv.conf being changed by NM
  sed -re '/DNS[[:digit:]]+=/d' -i $eth_card
  sed -i /PEERDNS/d $eth_card

  echo "PEERDNS=\"no\"" >> $eth_card
  echo "DNS1=\"${nameserver1}\"" >> $eth_card
  echo "DNS2=\"${nameserver2}\"" >> $eth_card

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
done

# nmcli help connection
# -g, --get-values <field,...>|all|common  shortcut for -m tabular -t -f
eth_cards="$(nmcli -g name connection show)"
for eth_card in $eth_cards
do
  nmcli connection modify $eth_card \
    ipv4.ignore-auto-dns "true"


  # Totally disable IPV6
  if [[ $disable_ipv6 -eq 1 ]] ; then
    nmcli connection modify $eth_card \
      ipv6.method "disabled" \
      ipv6.addr-gen-mode "stable-privacy" \
      ipv6.ignore-auto-dns "true" \
      ipv6.ignore-auto-routes "true" \
      ipv6.never-default "true"
  fi
done


# Activate config
sysctl -p /etc/sysctl.d/99-custom-sysctl.conf

set -x
# To make sure NM config is loaded into memory (such as: /etc/NetworkManager/conf.d/90-dns-none.conf)
systemctl restart NetworkManager
sleep 1

# NM should not be stopped or started, using nmcli to manipulate NM instead
nmcli c reload
sleep 1
set +x
#if [[ $? -eq 0 ]]; then
#  nmcli n off; nmcli n on
#fi

#-----------------------------------------------------------------------------------------
#SELINUX OFF
#-----------------------------------------------------------------------------------------
# Disable SELINUX temporary
setenforce 0
# Disable SELINUX permanently (Only clear policy rules)
sed -i s/'SELINUX=enforcing'/'SELINUX=disabled'/ /etc/selinux/config

# RHEL 9 still have to disable SELINUX from kernel
rpm --quiet -q grubby || dnf install -y grubby
grubby --update-kernel ALL --args selinux=0

#-----------------------------------------------------------------------------------------
#Setup timezone
#-----------------------------------------------------------------------------------------
timedatectl set-timezone "${current_timezone}"

#-----------------------------------------------------------------------------------------
#Setup chrony
#-----------------------------------------------------------------------------------------
sed -i /chronyd/d /etc/crontab
echo '*/5 * * * * root chronyd -q "pool pool.ntp.org iburst" >/dev/null 2>/dev/null ; hwclock -w  >/dev/null 2>/dev/null' >> /etc/crontab

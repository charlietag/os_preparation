# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

#-----------------------------------------------------------------------------------------
#Solve sshd login waiting issue (GSSAuth)
#-----------------------------------------------------------------------------------------
sed -ri s/'#[[:space:]]+GSSAPIAuthentication yes'/'GSSAPIAuthentication no'/ /etc/ssh/sshd_config /etc/ssh/ssh_config /etc/ssh/sshd_config.d/* /etc/ssh/ssh_config.d/*
sed -ri s/'#[[:space:]]+GSSAPIAuthentication no'/'GSSAPIAuthentication no'/ /etc/ssh/sshd_config /etc/ssh/ssh_config /etc/ssh/sshd_config.d/* /etc/ssh/ssh_config.d/*
sed -i s/'GSSAPIAuthentication yes'/'#GSSAPIAuthentication yes'/ /etc/ssh/sshd_config /etc/ssh/ssh_config /etc/ssh/sshd_config.d/* /etc/ssh/ssh_config.d/*
# Disable sshd acceptenv
sed -e '/^AcceptEnv/ s/^#*/#/' -i /etc/ssh/sshd_config

# Disable sshd UseDNS
sed -i '/UseDNS/d' /etc/ssh/sshd_config
echo "UseDNS no" >> /etc/ssh/sshd_config


# Change listen port
sed -i '/Port /d' /etc/ssh/sshd_config
echo "Port ${ssh_listen_port}" >> /etc/ssh/sshd_config

# Change listen address
sed -i '/ListenAddress /d' /etc/ssh/sshd_config
echo "ListenAddress ${ssh_listen_address}" >> /etc/ssh/sshd_config

# Add DenyGroups
sed -i '/DenyGroups /d' /etc/ssh/sshd_config
echo "DenyGroups no-ssh-group" >> /etc/ssh/sshd_config


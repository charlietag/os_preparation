# Ref. https://docs.oracle.com/en/operating-systems/oracle-linux/8/software-management/dnf-automatic.html
rpm --quiet -q dnf-automatic || dnf -y install dnf-automatic 

sed -Ei "s/^email_from = [[:print:]]+/email_from = root@$(hostname)/g" /etc/dnf/automatic.conf 

# About timer in systemd (chinese infomation)
  # https://www.ruanyifeng.com/blog/2018/03/systemd-timer.html
systemctl enable --now dnf-automatic.timer

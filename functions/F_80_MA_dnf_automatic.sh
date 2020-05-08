# Ref. https://docs.oracle.com/en/operating-systems/oracle-linux/8/software-management/dnf-automatic.html
rpm --quiet -q dnf-automatic || dnf -y install dnf-automatic 

sed -Ei "s/^email_from = [[:print:]]+/email_from = root@$(hostname)/g" /etc/dnf/automatic.conf 

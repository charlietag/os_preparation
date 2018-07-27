# ----------------------------------
# Content
# ----------------------------------
# All content is stored as below by default
# /var/lib/docker/

# ----------------------------------
# Avoid docker info warning
# ----------------------------------
local docker_sysctl_conf="/etc/sysctl.conf"
sed -i '/bridge-nf-call-iptables/d' $docker_sysctl_conf
sed -i '/bridge-nf-call-ip6tables/d' $docker_sysctl_conf

echo "net.bridge.bridge-nf-call-iptables = 1" >> $docker_sysctl_conf
echo "net.bridge.bridge-nf-call-ip6tables = 1" >> $docker_sysctl_conf
sysctl -p

# ----------------------------------
# prerequisite packages
# ----------------------------------
yum install -y  yum-utils \
                device-mapper-persistent-data \
                lvm2


# ----------------------------------
# Install docker-ce
# ----------------------------------
echo "---------------"
echo "Install docker-ce"
echo "---------------"
yum install -y docker-ce

local docker_version="/var/lib/docker_version.txt"
local docker_version_old="/var/lib/$(date +"%Y%m%d-%H%M%S")_docker_version.txt"
echo "---------------"
echo "docker version noted at ${docker_version}"
echo "---------------"

if [[ -s $docker_version ]]; then
  \cp -a $docker_version "${docker_version_old}" && docker -v > $docker_version
else
  docker -v > $docker_version
fi
docker -v

systemctl start docker
# ----------------------------------
# By default, disable docker onboot
# ----------------------------------
systemctl disable docker

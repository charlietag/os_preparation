# ----------------------------------
# Content
# ----------------------------------
# All content is stored as below by default
# /var/lib/docker/


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
echo "---------------"
echo "docker version noted at ${docker_version}"
echo "---------------"

if [[ -s $docker_version ]]; then
  \cp -a $docker_version "${docker_version}_$(date +"%Y%m%d-%H%M%S")" && docker -v > $docker_version
else
  docker -v > $docker_version
fi
docker -v

systemctl start docker
# ----------------------------------
# By default, disable docker onboot
# ----------------------------------
systemctl disable docker

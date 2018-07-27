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

echo "---------------"
echo "docker version noted at /var/lib/docker_version.txt"
echo "---------------"
\cp -a --backup=t /var/lib/docker_version.txt /var/lib/docker_version_old.txt && docker -v > /var/lib/docker_version.txt
docker -v

# ----------------------------------
# By default, disable docker onboot
# ----------------------------------
systemctl disable docker

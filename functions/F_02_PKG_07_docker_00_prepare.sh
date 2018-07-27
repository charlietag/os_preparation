# ----------------------------------
# remove old version docker
# ----------------------------------
yum remove -y docker \
              docker-client \
              docker-client-latest \
              docker-common \
              docker-latest \
              docker-latest-logrotate \
              docker-logrotate \
              docker-selinux \
              docker-engine-selinux \
              docker-engine


# ----------------------------------
# Install docker-ce repo
# Only enable "stable"
# ----------------------------------
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

#yum-config-manager --enable docker-ce-edge
#yum-config-manager --enable docker-ce-test
#yum-config-manager --disable docker-ce-edge
#yum-config-manager --disable docker-ce-test

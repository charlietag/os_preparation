# =====================
# Enable databag
# =====================
# RENDER_CP

# ----------------------------------
# remove old version of docker
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
# remove old version of docker-ce
# WARN: every new version of docker-ce might not surport content /var/lib/docker from old version of docker-ce
# ----------------------------------
yum remove -y docker-ce

\cp -a --backup=t /var/lib/docker /var/lib/docker_old && rm -rf /var/lib/docker

# ----------------------------------
# Install docker-ce repo
# Only enable "stable"
# ----------------------------------
yum-config-manager \
    --add-repo \
    ${docker_yum_repo}

#yum-config-manager --enable docker-ce-edge
#yum-config-manager --enable docker-ce-test
#yum-config-manager --disable docker-ce-edge
#yum-config-manager --disable docker-ce-test

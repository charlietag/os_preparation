# =====================
# Enable databag
# =====================
# RENDER_CP

# ----------------------------------
# Stop docker before uninstall
# ----------------------------------
systemctl stop docker

# ----------------------------------
# remove old version of docker
# remove old version of docker-ce
# WARN: every new version of docker-ce might not surport content /var/lib/docker from old version of docker-ce
# ----------------------------------
echo "---------------"
echo "uninstall docker-ce, docker-*"
echo "---------------"
yum remove -y docker \
              docker-client \
              docker-client-latest \
              docker-common \
              docker-latest \
              docker-latest-logrotate \
              docker-logrotate \
              docker-selinux \
              docker-engine-selinux \
              docker-engine \
              docker-ce  # remove old version of docker-ce


# ----------------------------------
# remove docker files
# ----------------------------------
local docker_data="/var/lib/docker"
if [[ -d $docker_data ]]; then
  echo "---------------"
  echo "delete old ${docker_data}"
  echo "---------------"
  \cp -a ${docker_data} "$(date +"%Y%m%d-%H%M%S")_${docker_data}" && rm -rf ${docker_data}
fi

# ----------------------------------
# Install docker-ce repo
# Only enable "stable"
# ----------------------------------
echo "---------------"
echo "add docker-ce repo"
echo "---------------"
yum-config-manager \
    --add-repo \
    ${docker_yum_repo}

#yum-config-manager --enable docker-ce-edge
#yum-config-manager --enable docker-ce-test
#yum-config-manager --disable docker-ce-edge
#yum-config-manager --disable docker-ce-test

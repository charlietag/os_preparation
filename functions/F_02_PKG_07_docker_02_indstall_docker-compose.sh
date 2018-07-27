# =====================
# Enable databag
# =====================
# RENDER_CP

# ----------------------------------
# Install latest version of docker-comopose
# ----------------------------------
curl -L "${docker_compose_url}" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

docker-compose --version

# ----------------------------------
# Install latest version of docker-comopose
# ----------------------------------
local docker_compose_ver="/var/lib/docker-compose_version.txt"
local docker_compose_ver_old="/var/lib/$(date +"%Y%m%d-%H%M%S")_docker-compose_version.txt"
echo "---------------"
echo "docker-compose version noted at ${docker_compose_ver}"
echo "---------------"

if [[ -s $docker_compose_ver ]]; then
  \cp -a $docker_compose_ver "${docker_compose_ver_old}" && docker-compose -v > $docker_compose_ver
else
  docker-compose -v > $docker_compose_ver
fi

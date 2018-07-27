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

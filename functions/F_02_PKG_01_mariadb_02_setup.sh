# =====================
# Enable databag
# =====================
# RENDER_CP

# Setup bind-address
echo "==============================="
echo "  Setup mariadb config"
echo "==============================="
sed -e '/^bind-address/ s/^#*/#/' -i /etc/my.cnf.d/server.cnf
sed -e "/^\[mysqld\]/a bind-address = ${mariadb_listen_address}" -i /etc/my.cnf.d/server.cnf

systemctl restart mariadb

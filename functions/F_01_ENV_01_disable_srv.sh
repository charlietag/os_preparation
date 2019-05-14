# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

#-----------------------------------------------------------------------------------------
# Stop and disable services
#-----------------------------------------------------------------------------------------
for disabled_service in ${disabled_services[@]}
do
  echo "Stopping service ${disabled_service}......"
  systemctl stop ${disabled_service}
  systemctl disable ${disabled_service}
done

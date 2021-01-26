# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

#-----------------------------------------------------------------------------------------
# Stop and disable services
#-----------------------------------------------------------------------------------------
# Do "F_01_ENV_01_disable_srv.sh" again, to make sure to disable no use services

for disabled_service in ${disabled_services[@]}
do
  echo ""
  echo "-----------------------------"
  echo "Stopping service ${disabled_service}......"
  echo "-----------------------------"
  systemctl stop ${disabled_service}
  systemctl disable ${disabled_service}
  echo ""
  echo ""
done

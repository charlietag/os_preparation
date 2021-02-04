# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

#-----------------------------------------------------------------------------------------
# Stop and disable services
#-----------------------------------------------------------------------------------------
for disabled_service in ${disabled_services[@]}
do
  echo ""
  echo "-----------------------------"
  echo "Stopping service \"${disabled_service}\" ..."
  echo "-----------------------------"
  systemctl stop ${disabled_service}
  systemctl disable ${disabled_service}
  echo ""
  echo ""
done

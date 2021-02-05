# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

#-----------------------------------------------------------------------------------------
# Stop and disable services
#-----------------------------------------------------------------------------------------
local disable_msg
for disabled_service in ${disabled_services[@]}
do
  disable_msg="$(systemctl disable ${disabled_service})"
  if [[ $? -eq 0 ]]; then
    echo ""
    echo "-----------------------------"
    echo "Stopping service \"${disabled_service}\" ..."
    echo "-----------------------------"
    echo -e "${disable_msg}"
    systemctl stop ${disabled_service}
    echo ""
    echo ""

  fi
done

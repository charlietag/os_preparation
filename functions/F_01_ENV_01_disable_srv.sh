# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable

#-----------------------------------------------------------------------------------------
# Stop and disable services
#-----------------------------------------------------------------------------------------
echo ""
local disable_msg
for disabled_service in ${disabled_services[@]}
do
  disable_msg="$(systemctl disable ${disabled_service} 2>&1)"
  if [[ $? -eq 0 ]]; then
    echo "-----------------------------"
    echo "Stopping service \"${disabled_service}\" ..."
    echo "-----------------------------"
    echo -e "${disable_msg}"
    systemctl stop ${disabled_service}
    echo ""
    echo ""

  fi
done

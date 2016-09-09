# =====================
# Enable databag
# =====================
# RENDER_CP


# ======= Define Var ===========
local service_name=""

# ======= Define Var ===========

echo "================================"
echo "    Toggling Services"
echo "================================"

for toggle_service in ${toggle_services[@]}
do
  service_name="${toggle_service}.service"
  echo "systemctl ${toggle} \"${service_name}\""

  if [ "${toggle}" == "enable" ]
  then
    systemctl enable ${service_name}
  else
    systemctl disable ${service_name}
  fi
done

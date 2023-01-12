# -------------------------------------------------------
# Available puma services
# -------------------------------------------------------
list_puma_services_available () {
  echo "-------------------------------------------------------"
  # echo "Available puma service NAMES (based on Nginx configs):"
  # echo "${NGINX_RAILS_PATH}"
  echo "Puma service names: checkout ${NGINX_RAILS_PATH}"
  echo "-------------------------------------------------------"
  echo -e "${PUMA_SERVICE_NAMES}" | sed -re 's/^/    /g'
  # for puma_service_name in ${PUMA_SERVICE_NAMES[@]}; do
  #   echo "    ${puma_service_name}"
  # done
  echo ""
}

# -------------------------------------------------------
# List Puma systemd services
# -------------------------------------------------------
list_puma_services_systemd () {
  echo "-------------------------------------------------------"
  echo "Systemd status:"
  echo "-------------------------------------------------------"
  local puma_systemd_lists="$(systemctl list-unit-files | grep "puma" | sed -re 's/^/    /g')"
  local puma_systemd_names="$(echo -e "${puma_systemd_lists}" | grep "puma_" | awk -F'puma_|.service' '{print $2}')"

  echo -e "${puma_systemd_lists}"
  echo ""

  if [[ "${puma_systemd_names}" != "${PUMA_SERVICE_NAMES}" ]]; then
    echo "(WARN) Nginx configs do not match systemd configs!"
    echo "(Recommend) regenerate systemd configs:"
    echo ""
    echo "${THIS_SCRIPT_NAME} -g"
    echo ""
  fi
}

# -------------------------------------------------------
# List running puma process
# -------------------------------------------------------
list_puma_services_processes () {
  local puma_running_processes="$(ps aux |grep -E '[[:digit:]]+[[:space:]]+puma' | sed -re 's/^/    /g')"
  local puma_running_names="$(echo -e "${puma_running_processes}" | grep -Eo '\[[[:print:]]+\]' | sort -n | uniq | sed -re 's/^\[//g' -re 's/\]$//g' | sed -re ':a;N;$!ba;s/\n/,/g')"
  echo "-------------------------------------------------------"
  echo "Running Puma Processes: ${puma_running_names}"
  echo "-------------------------------------------------------"
  echo -e "${puma_running_processes}"
  echo ""
}

# -------------------------------------------------------
# List Puma Zombie Processes
# -------------------------------------------------------
list_puma_services_zombie () {
  echo "-------------------------------------------------------"
  echo "Puma Zombie Processes:"
  echo "-------------------------------------------------------"
  local puma_service_names_pattern="$(echo -e "${PUMA_SERVICE_NAMES}" | xargs -I{} echo '\[{}\]' | sed -re ':a;N;$!ba;s/\n/|/g')"
  local puma_running_processes="$(ps aux |grep -E '[[:digit:]]+[[:space:]]+puma' | sed -re 's/^/    /g')"
  echo -e "${puma_running_processes}" | grep -vE "${puma_service_names_pattern}"
  echo ""

}
